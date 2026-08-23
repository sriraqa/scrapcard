//
//  ContentView.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2025-08-28.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .inbox

    var body: some View {
        ZStack(alignment: .bottom) {
            currentTabView
                .padding(.horizontal)
                .padding(.bottom)

            CustomTabBar(selectedTab: $selectedTab)
                .padding(.horizontal)
                .padding(.bottom, 8)
        }
    }

    @ViewBuilder
    private var currentTabView: some View {
        switch selectedTab {
        case .inbox:
            InboxView()
        case .book, .profile:
            DraftView()
        }
    }
}

#Preview {
    ContentView()
}
