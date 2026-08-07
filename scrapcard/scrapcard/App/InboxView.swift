//
//  InboxView.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2026-08-06.
//

import SwiftUI

struct InboxView: View {
  var body: some View {
    VStack {
      HStack {
        IconButtonView(systemName: "bell") {
            print("notification")
        }
        Spacer()
        Text("Your Inbox")
          .font(Font.custom("Sen-Regular", size: 24))
        Spacer()
        IconButtonView(systemName: "person") {
          print("add")
        }
      }
      Spacer()
    }
  }
}

#Preview {
  InboxView()
}
