//
//  ButtonView.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2026-08-06.
//

import SwiftUI

struct ButtonView: View {
    // MARK: - Properties
    let title: String
    var isDisabled: Bool = false
    let action: () -> Void
    
    // Environment property to automatically react if .disabled(...) is called externally
    @Environment(\.isEnabled) private var isEnabled
    
    private var isButtonDisabled: Bool {
        isDisabled || !isEnabled
    }
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
          Text(title)
            .font(Font.custom("Sen-Bold", size: 20))
            .foregroundColor(Color("Background"))
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                isButtonDisabled ? Color("DarkestBackground") : Color("TextPrimary")
            )
            .clipShape(RoundedRectangle(cornerRadius: 64))
        }
        .disabled(isButtonDisabled)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        // 1. Normal Active State
        ButtonView(title: "Continue") {
            print("Button tapped!")
        }
        
        // 2. Disabled via Prop
        ButtonView(title: "Disabled Button", isDisabled: true) {
            print("Won't trigger")
        }
        
        // 3. Disabled via standard SwiftUI .disabled() modifier
        ButtonView(title: "Native Disabled") {
            print("Won't trigger")
        }
        .disabled(true)
    }
    .padding()
}
