//
//  CustomTabBar.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2026-08-06.
//

import SwiftUI

// MARK: - Tab Model
enum Tab: String, CaseIterable {
  case inbox = "Inbox"
  case book = "Book"
  case profile = "Profile"
  
  var iconName: String {
    switch self {
    case .inbox: return "tray"
    case .book: return "book"
    case .profile: return "person"
    }
  }
}

// MARK: - Custom Tab Bar
struct CustomTabBar: View {
  @Binding var selectedTab: Tab
    
  var body: some View {
      HStack(spacing: 0) {
        ForEach(Tab.allCases, id: \.self) { tab in
          Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
              selectedTab = tab
            }
          } label: {
            VStack(spacing: 4) {
              Image(systemName: tab.iconName)
                .font(.system(size: 20, weight: .semibold))
              
              Text(tab.rawValue)
                .font(Font.custom("Sen-Bold", size: 12))
            }
            .foregroundColor(Color("TextPrimary"))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
              selectedTab == tab ? Color("DarkestBackground") : Color.clear
            )
            .clipShape(RoundedRectangle(cornerRadius: 32))
          }
        }
      }
      .padding(6) // Inner padding so active tab background has room
      .frame(maxWidth: .infinity)
      .frame(height: 60)
      .background(Color("DarkerBackground"))
      .clipShape(Capsule()) // Fully rounded outer bar
  }
}
