//
//  ScrapCardView.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2025-08-31.
//

import SwiftUI

struct ScrapCardView: View {
    @State private var vertical = 0.0
    @State private var horizontal = 0.0

    let date: Date

    @Binding var text: String
    @FocusState private var textFieldFocused: Bool

    var body: some View {
        let limitedText = Binding<String>(
            get: { text },
            set: { newValue in
                guard newValue.components(separatedBy: .newlines).count <= 4 else {
                    return
                }

                text = newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "" : newValue
            }
        )

        VStack(spacing: 16) {
            cardImage
            metadataRow
            textEditor(limitedText: limitedText)
            Spacer()
            watermark
        }
        .padding(24)
        .frame(maxWidth: 363)
        .aspectRatio(363.0 / 575.0, contentMode: .fit)
        .background(.white)
        .cornerRadius(3)
        .shadow(color: .black.opacity(0.1), radius: 3, x: -2, y: 4)
        .foregroundStyle(Color.textPrimary)
        .rotation3DEffect(.degrees(-vertical), axis: (x: 1, y: 0, z: 0))
        .rotation3DEffect(.degrees(-horizontal), axis: (x: 0, y: 1, z: 0))
        .gesture(cardTiltGesture)
    }

    private var cardImage: some View {
        AsyncImage(url: URL(string: "")) { image in
            image
                .resizable()
                .aspectRatio(4.0 / 3.0, contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } placeholder: {
            Image("exampleImg")
                .resizable()
                .aspectRatio(4.0 / 3.0, contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .clipped()
    }

    private var metadataRow: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text(date.formattedMMddyyyy())
                    .font(.senRegular(size: 20))
                Line()
            }

            Rectangle()
                .stroke(Color.textPrimary, lineWidth: 1)
                .frame(width: 64, height: 64)
        }
    }

    private func textEditor(limitedText: Binding<String>) -> some View {
        ZStack(alignment: .top) {
            VStack(spacing: 23) {
                ForEach(0..<4, id: \.self) { _ in
                    Line()
                        .padding([.top, .bottom], 4)
                }
            }
            .padding(.top, 28)

            TextEditor(text: limitedText)
                .transparentScrolling()
                .lineSpacing(8)
                .font(.senRegular(size: 20))
                .focused($textFieldFocused)
                .onSubmit {
                    trimText()
                }
                .lineLimit(4, reservesSpace: true)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
        }
    }

    private var watermark: some View {
        Text("SCRAPCARD")
            .font(.senRegular(size: 14))
    }

    private var cardTiltGesture: some Gesture {
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
    }

    private func trimText() {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        text = trimmedText.isEmpty ? "" : trimmedText
    }
}

extension View {
    @ViewBuilder
    func transparentScrolling() -> some View {
        if #available(iOS 16.0, *) {
            scrollContentBackground(.hidden)
        } else {
            onAppear {
                UITextView.appearance().backgroundColor = .clear
            }
        }
    }
}
