//
//  ContentView.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2025-08-28.
//

import SwiftUI

struct ShareRequest: Encodable {
  let text: String
  let date: Date
}

struct ShareResponse: Decodable {
  let success: Bool
  let message: String
}

struct ContentView: View {
  @State private var selectedTab: Tab = .inbox
  
  var body: some View {
    ZStack(alignment: .bottom) {
      // Main content based on active tab
      if (selectedTab == .inbox) {
        InboxView()
          .padding(.horizontal)
          .padding(.bottom)
      } else {
        DraftView()
          .padding(.horizontal)
          .padding(.bottom)
      }
      
      // Floating Rounded Tab Bar
      CustomTabBar(selectedTab: $selectedTab)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
  }
}

#Preview {
    ContentView()
}
