//
//  RootView.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2025-08-28.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject private var authSession: AuthSession

    var body: some View {
        Group {
            if authSession.isAuthenticated {
                ContentView()
            } else {
                AuthView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
}

#Preview {
    RootView()
        .environmentObject(AuthSession())
}
