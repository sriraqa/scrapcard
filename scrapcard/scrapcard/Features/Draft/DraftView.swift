//
//  DraftView.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2026-08-06.
//

import SwiftUI

struct DraftView: View {
    @State private var text = ""
    @State private var isLoading = false
    @State private var statusMessage: String?

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                IconButtonView(systemName: "arrow.left") {
                    print("back")
                }

                Spacer()

                Text("Draft")
                    .font(.senRegular(size: 24))

                Spacer()

                IconButtonView(systemName: "checkmark", variant: .blue, isDisabled: isLoading) {
                    saveDraft()
                }
            }

            ScrapCardView(date: Date(), text: $text)

            if let statusMessage {
                Text(statusMessage)
                    .font(.senRegular(size: 14))
                    .foregroundStyle(Color.textPrimary)
            }

            Spacer()
        }
    }

    private func saveDraft() {
        isLoading = true
        statusMessage = nil

        Task {
            do {
                let payload = ShareRequest(text: text, date: Date())
                let response: ShareResponse = try await APIService.shared.request(
                    endpoint: "/share",
                    method: .POST,
                    body: payload
                )

                statusMessage = response.message
                print(response)
            } catch {
                statusMessage = "Failed to share"
                print(error)
            }

            isLoading = false
        }
    }
}

#Preview {
    DraftView()
}
