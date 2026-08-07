//
//  DraftView.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2026-08-06.
//

import SwiftUI

struct DraftView: View {
  @State private var text: String = ""
  @State private var isLoading = false
  @State private var statusMessage: String?
  
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
    VStack(spacing: 16) {
      //Temp button to show mock endpoint call
      HStack {
        IconButtonView(systemName: "arrow.left") {
            print("back")
        }
        Spacer()
        Text("Draft")
          .font(Font.custom("Sen-Regular", size: 24))
        Spacer()
        IconButtonView(systemName: "checkmark", variant: .blue) {
            onSave(currText: text)
        }
      }
      Scrapcard(date: Date(), text: $text)
      Spacer()
    }
  }
}

#Preview {
  DraftView()
}
