//
//  ContentView.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2025-08-28.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
          Scrapcard(date: Date(), text: "test text")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
