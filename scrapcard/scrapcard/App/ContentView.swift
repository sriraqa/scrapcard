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
  @State private var tabConfig: FlexibleTabbar.Config = .init(activeTab: 0)
  
  func onSave(currText: String) -> Void {
    isLoading = true
    statusMessage = nil

    let payload = ShareRequest(
      text: currText,
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
    ZStack(alignment: .bottom) {
      FlexibleTabbar(tabs: [
        .init(symbol: "house"),
        .init(symbol: "book"),
        .init(symbol: "person")
      ], config: $tabConfig)
      VStack(spacing: 16) {
        //Temp button to show mock endpoint call
        Button(action: { onSave(currText: text) }) {
          Label("Share", systemImage: "paperplane.fill")
            .bold()
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                  .fill(Color.textPrimary)
            )
        }
        Scrapcard(date: Date(), text: $text)
      }
      .padding()
    }
  }
}

#Preview {
    ContentView()
}
