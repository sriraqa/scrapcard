//
//  ContentView.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2025-08-28.
//

import SwiftUI

struct ContentView: View {
  @State private var text: String = ""
  
    var body: some View {
        VStack {
          Scrapcard(date: Date(), text: $text)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
