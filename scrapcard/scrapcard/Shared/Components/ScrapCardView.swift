//
//  Scrapcard.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2025-08-31.
//

import SwiftUI

struct Scrapcard: View {
  @State var vertical: Double = 0
  @State var horizontal: Double = 0
  
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
      .rotation3DEffect(.degrees(-vertical), axis: (x: 1, y:0, z: 0))
      .rotation3DEffect(.degrees(-horizontal), axis: (x: 0, y: 1, z: 0))
      .gesture(
        DragGesture(minimumDistance: 0)
          .onChanged { value in
            withAnimation {
              vertical = min(max(Double(value.translation.height / 20), -20), 20)
              horizontal = min(max(Double(value.translation.width / 20), -15), 15)
            }
          }
          .onEnded { _ in
            withAnimation(.easeOut(duration: 0.5)) {
              vertical = 0
              horizontal = 0
            }
          }
      )
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
