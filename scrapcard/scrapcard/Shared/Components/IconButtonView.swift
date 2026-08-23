//
//  IconButtonView.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2026-08-06.
//

import SwiftUI

struct IconButtonView: View {
    enum Variant {
        case defaultStyle
        case blue

        var backgroundColor: Color {
            switch self {
            case .defaultStyle:
                return Color("DarkerBackground")
            case .blue:
                return Color("Primary")
            }
        }

        var foregroundColor: Color {
            switch self {
            case .defaultStyle:
                return Color("TextPrimary")
            case .blue:
                return Color("Background")
            }
        }
    }

    let systemName: String
    var variant: Variant = .defaultStyle
    var isDisabled = false
    let action: () -> Void

    @Environment(\.isEnabled) private var isEnabled

    private var isButtonDisabled: Bool {
        isDisabled || !isEnabled
    }

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(isButtonDisabled ? Color("TextPrimary").opacity(0.25) : variant.foregroundColor)
                .frame(width: 52, height: 52)
                .background(isButtonDisabled ? Color("DarkestBackground") : variant.backgroundColor)
                .clipShape(Circle())
        }
        .disabled(isButtonDisabled)
    }
}

#Preview {
    HStack(spacing: 20) {
        IconButtonView(systemName: "plus") {
            print("Default icon tapped")
        }

        IconButtonView(systemName: "arrow.up", variant: .blue) {
            print("Blue icon tapped")
        }

        IconButtonView(systemName: "xmark", isDisabled: true) {
            print("Disabled icon tapped")
        }
    }
    .padding()
}
