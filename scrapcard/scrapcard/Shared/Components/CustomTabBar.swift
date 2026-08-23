//
//  CustomTabBar.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2026-08-06.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case inbox = "Inbox"
    case book = "Book"
    case profile = "Profile"

    var iconName: String {
        switch self {
        case .inbox:
            return "tray"
        case .book:
            return "book"
        case .profile:
            return "person"
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    @Namespace private var animationNamespace

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { tab in
                tabButton(for: tab)
            }
        }
        .padding(6)
        .frame(maxWidth: .infinity)
        .frame(height: 64)
        .background(Color("DarkerBackground"))
        .clipShape(Capsule())
    }

    private func tabButton(for tab: Tab) -> some View {
        let isSelected = selectedTab == tab

        return Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: tab.iconName)
                    .font(.senSemiBold(size: 20))
                    .scaleEffect(isSelected ? 1.2 : 1.0)

                Text(tab.rawValue)
                    .font(.senBold(size: 12))
                    .scaleEffect(isSelected ? 1.2 : 1.0)
            }
            .foregroundColor(Color("TextPrimary"))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                if isSelected {
                    RoundedRectangle(cornerRadius: 32)
                        .fill(Color("DarkestBackground"))
                        .matchedGeometryEffect(id: "activeTabPill", in: animationNamespace)
                }
            }
        }
        .buttonStyle(TabButtonStyle())
    }
}

struct TabButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}
