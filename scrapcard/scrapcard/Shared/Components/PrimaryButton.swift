//
//  PrimaryButton.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2026-08-06.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    var isDisabled = false
    let action: () -> Void

    @Environment(\.isEnabled) private var isEnabled

    private var isButtonDisabled: Bool {
        isDisabled || !isEnabled
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.senBold(size: 20))
                .foregroundColor(Color("Background"))
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(isButtonDisabled ? Color("DarkestBackground") : Color("TextPrimary"))
                .clipShape(RoundedRectangle(cornerRadius: 64))
        }
        .disabled(isButtonDisabled)
    }
}

#Preview {
    VStack(spacing: 20) {
        PrimaryButton(title: "Continue") {
            print("Button tapped!")
        }

        PrimaryButton(title: "Disabled Button", isDisabled: true) {
            print("Won't trigger")
        }

        PrimaryButton(title: "Native Disabled") {
            print("Won't trigger")
        }
        .disabled(true)
    }
    .padding()
}
