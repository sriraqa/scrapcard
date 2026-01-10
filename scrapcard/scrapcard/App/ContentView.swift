//
//  ContentView.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2025-08-28.
//

import SwiftUI

struct ShareRequest: Encodable {
  let text: String
  let date: Date
}

struct ShareResponse: Decodable {
  let success: Bool
  let message: String
}

struct ContentView: View {
  @State private var text: String = ""
  @State private var isLoading = false
  @State private var statusMessage: String?
  
  func onSave() -> Void {
    isLoading = true
    statusMessage = nil

    let payload = ShareRequest(
      text: text,
      date: Date()
    )

    APIService.shared.request(
      endpoint: "/share", // mock endpoint
      method: .POST,
      body: payload
    ) { (result: Result<ShareResponse, Error>) in
      DispatchQueue.main.async {
        isLoading = false
        
        switch result {
        case .success(let response):
          statusMessage = response.message
          print(response)
          
        case .failure(let error):
          statusMessage = "Failed to share"
          print(error)
        }
      }
    }
  }
  
  var body: some View {
    VStack(spacing: 16) {
      Scrapcard(date: Date(), text: $text)
      Button(action: onSave) {
        Label("Share", systemImage: "paperplane.fill")
          .bold()
          .frame(maxWidth: .infinity)   // take full width
          .padding()
          .foregroundStyle(.white)
          .background(
              RoundedRectangle(cornerRadius: 8, style: .continuous)
                  .fill(Color.blue)
          )
      }
    }
    .padding()
  }
}

#Preview {
    ContentView()
}
