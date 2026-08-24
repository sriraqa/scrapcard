//
//  Auth.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2025-08-31.
//

import AuthenticationServices
import Foundation
import Security
import SwiftUI

struct AuthenticatedUser: Codable, Equatable {
    let id: String
    let email: String?
    let fullName: String?
}

struct AppleSignInRequest: Encodable {
    let userIdentifier: String
    let identityToken: String
    let authorizationCode: String
    let email: String?
    let fullName: String?
}

struct AuthResponse: Codable {
    let accessToken: String
    let refreshToken: String?
    let user: AuthenticatedUser
}

@MainActor
final class AuthSession: ObservableObject {
    @Published private(set) var user: AuthenticatedUser?
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let apiService: APIService
    private let tokenStore: TokenStore

    var isAuthenticated: Bool {
        user != nil && tokenStore.accessToken != nil
    }

    init(
        apiService: APIService = .shared,
        tokenStore: TokenStore = KeychainTokenStore()
    ) {
        self.apiService = apiService
        self.tokenStore = tokenStore
        restoreSession()
    }

    func signIn(with credential: ASAuthorizationAppleIDCredential) async {
        guard let identityTokenData = credential.identityToken,
              let identityToken = String(data: identityTokenData, encoding: .utf8),
              let authorizationCodeData = credential.authorizationCode,
              let authorizationCode = String(data: authorizationCodeData, encoding: .utf8) else {
            errorMessage = "Apple did not return the credentials needed to sign in."
            return
        }

        isLoading = true
        errorMessage = nil

        let request = AppleSignInRequest(
            userIdentifier: credential.user,
            identityToken: identityToken,
            authorizationCode: authorizationCode,
            email: credential.email,
            fullName: credential.fullName?.formatted()
        )

        do {
            let response: AuthResponse = try await apiService.request(
                endpoint: "/auth/apple",
                method: .POST,
                body: request
            )
            tokenStore.accessToken = response.accessToken
            tokenStore.refreshToken = response.refreshToken
            user = response.user
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    #if DEBUG
    func signInAsDeveloper() {
        tokenStore.accessToken = "dev-access-token"
        tokenStore.refreshToken = "dev-refresh-token"
        user = AuthenticatedUser(
            id: "dev-user",
            email: "qiaosarah8@gmail.com",
            fullName: "Dev User"
        )
        errorMessage = nil
    }
    #endif

    func signOut() {
        tokenStore.clear()
        user = nil
        errorMessage = nil
    }

    private func restoreSession() {
        guard tokenStore.accessToken != nil else { return }

        // Replace this placeholder by calling GET /me when the backend endpoint exists.
        user = AuthenticatedUser(id: "saved-session", email: nil, fullName: nil)
    }
}

struct AuthView: View {
    @EnvironmentObject private var authSession: AuthSession
    @State private var selectedCharacter = ScrapcardAssets.characterImages.randomElement() ?? "character_cat"

    var body: some View {
        VStack(spacing: 28) {
            watermark()
                .frame(maxWidth: .infinity, alignment: .center)

            Spacer()

            CharacterOrbitView(
                characterName: selectedCharacter,
                stickerNames: ScrapcardAssets.stickerImages
            )

            Spacer()

            signInContent
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var signInContent: some View {
        VStack(spacing: 12) {
            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                handleAuthorization(result)
            }
            .signInWithAppleButtonStyle(.black)
            .frame(height: 52)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .disabled(authSession.isLoading)

            #if DEBUG
            PrimaryButton(title: "Continue as Dev User") {
                authSession.signInAsDeveloper()
            }
            .disabled(authSession.isLoading)
            #endif

            if authSession.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
            }

            if let errorMessage = authSession.errorMessage {
                Text(errorMessage)
                    .font(.senRegular(size: 14))
                    .foregroundColor(.red)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func handleAuthorization(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                authSession.errorMessage = "Apple returned an unsupported credential."
                return
            }

            Task {
                await authSession.signIn(with: credential)
            }
        case .failure(let error):
            authSession.errorMessage = error.localizedDescription
        }
    }
  
    private func watermark() -> some View {
        VStack(spacing: 4) {
            Text("SCRAPCARD")
                .font(.senRegular(size: 24))

            Rectangle()
                .frame(width: 136, height: 2)
        }
    }
}


protocol TokenStore: AnyObject {
    var accessToken: String? { get set }
    var refreshToken: String? { get set }
    func clear()
}

final class KeychainTokenStore: TokenStore {
    private enum Key {
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
    }

    var accessToken: String? {
        get { readValue(for: Key.accessToken) }
        set { setValue(newValue, for: Key.accessToken) }
    }

    var refreshToken: String? {
        get { readValue(for: Key.refreshToken) }
        set { setValue(newValue, for: Key.refreshToken) }
    }

    func clear() {
        deleteValue(for: Key.accessToken)
        deleteValue(for: Key.refreshToken)
    }

    private func readValue(for key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess,
              let data = item as? Data else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    private func setValue(_ value: String?, for key: String) {
        guard let value else {
            deleteValue(for: key)
            return
        }

        let data = Data(value.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]

        let attributes: [String: Any] = [
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]

        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)

        if status == errSecItemNotFound {
            var addQuery = query
            addQuery.merge(attributes) { _, new in new }
            SecItemAdd(addQuery as CFDictionary, nil)
        }
    }

    private func deleteValue(for key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]

        SecItemDelete(query as CFDictionary)
    }

    private var service: String {
        Bundle.main.bundleIdentifier ?? "scrapcard.auth"
    }
}

#Preview {
    AuthView()
        .environmentObject(AuthSession())
}
