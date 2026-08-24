//
//  scrapcardApp.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2025-08-28.
//

import SwiftUI

@main
struct ScrapcardApp: App {
    @StateObject private var authSession = AuthSession()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authSession)
        }
    }
}
