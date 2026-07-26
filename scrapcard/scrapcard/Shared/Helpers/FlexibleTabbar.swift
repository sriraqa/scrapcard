//
//  FlexibleTabbar.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2026-07-26.
//

import SwiftUI

struct FlexibleTabbar: View {
  var tabs: [TabItem]
  @Binding var config: Config
  
  var body: some View {
//    GlassEffectContainer(spacing: 10) {
//      
//    }
  }
  
  struct Config {
    var activeTab: Int
  }
  
  struct TabItem {
    var symbol: String
  }
}
