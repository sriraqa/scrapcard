//
//  Scrapcard.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2025-08-31.
//

import SwiftUI

struct Scrapcard: View {
  let date: Date
  let text: String
  
    var body: some View {
      VStack(spacing: 16) {
        HStack(alignment: .top, spacing: 0) {
          VStack(alignment: .leading, spacing: 4) {
            Text(date.formattedMMddyyyy())
              .font(Font.custom("Sen-Regular", size: 20))
            Line()
          }
          //          Profile image
          Rectangle()
            .stroke(Color.textPrimary, lineWidth: 1)
            .frame(width: 64, height: 64)
        }
        VStack(spacing: 4) {
          Text(text)
            .font(Font.custom("Sen-Regular", size: 20))
          Line()
        }
        Spacer()
        Text("SCRAPCARD")
          .font(Font.custom("Sen-Regular", size: 14))
      }
      .padding(24)
      .frame(width: 363, height: 575, alignment: .center)
      .background(.white)

      .cornerRadius(3)
      .shadow(color: .black.opacity(0.1), radius: 3, x: -2, y: 4)
      .foregroundStyle(Color.textPrimary)
    }
}

#Preview {
    VStack {
      Scrapcard(date: Date(), text: "Today I went to the grocery store.")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color.gray
                    .ignoresSafeArea()
            }
}
