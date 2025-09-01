//
//  Scrapcard.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2025-08-31.
//

import SwiftUI

struct Scrapcard: View {
  let title: String
  let text: String
  
    var body: some View {
      VStack(spacing: 8) {
        Text(title)
          .font(Font.custom("Sen-Regular", size: 18))
        Text(text)
          .font(Font.custom("Sen-Regular", size: 18))
      }
      .frame(maxWidth: 362,maxHeight: 575)
      .background {
          Color.white
      }
    }
}

#Preview {
    VStack {
      Scrapcard(title: "Card Preview", text: "Today I went to the grocery store.")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color.gray
                    .ignoresSafeArea()
            }
}
