//
//  RootView.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2025-08-28.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        VStack {
          ContentView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blueLight)
        .ignoresSafeArea()
    }
}

#Preview {
    RootView()
}
