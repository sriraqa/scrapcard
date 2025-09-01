//
//  LineVIew.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2025-09-01.
//

import SwiftUI

struct Line: View {
    var body: some View {
      Rectangle()
        .foregroundColor(.clear)
        .frame(maxWidth: .infinity, maxHeight: 1)
        .background(Color.textPrimary)
    }
}
