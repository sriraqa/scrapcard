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
  
  @Binding var text: String
  @FocusState private var textFieldFocused: Bool
  
  func validate(newText: String) {
    let trimmedText = newText.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmedText == "" {
      text = ""
    }  else {
      text = trimmedText
    }
  }
  
  var body: some View {
    VStack(spacing: 16) {
      //TODO: Connect with backend for real image
      AsyncImage(url: URL(string: "")) { image in
        image
          .resizable()
          .aspectRatio(4/3, contentMode: .fill)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      } placeholder: {
        Image("exampleImg")
          .resizable()
          .aspectRatio(4/3, contentMode: .fill)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
      .frame(maxWidth: .infinity)
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .clipped()

      HStack(alignment: .top, spacing: 0) {
        VStack(alignment: .leading, spacing: 4) {
          Text(date.formattedMMddyyyy())
            .font(Font.custom("Sen-Regular", size: 20))
          Line()
        }
        // TODO: Profile image
        Rectangle()
          .stroke(Color.textPrimary, lineWidth: 1)
          .frame(width: 64, height: 64)
      }
      
      ZStack(alignment: .top) {
        VStack(spacing: 23) {
          ForEach(0..<4, id: \.self) { _ in
            Line()
              .padding([.top, .bottom], 4)
          }
        }
        .padding([.top], 28)
        TextEditor(text: $text)
          .transparentScrolling()
          .lineSpacing(8)
          .font(Font.custom("Sen-Regular", size: 20))
          .focused($textFieldFocused)
          .onSubmit {
            validate(newText: text)
          }
          .textInputAutocapitalization(.never)
          .disableAutocorrection(true)
      }
      Spacer()
      
      // Watermark
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

public extension View {
  func transparentScrolling() -> some View {
    if #available(iOS 16.0, *) {
      return scrollContentBackground(.hidden)
    } else {
      return onAppear {
          UITextView.appearance().backgroundColor = .clear
      }
    }
  }
}
