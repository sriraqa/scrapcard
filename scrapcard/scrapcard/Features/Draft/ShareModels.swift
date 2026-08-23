//
//  ShareModels.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2026-08-23.
//

import Foundation

struct ShareRequest: Encodable {
    let text: String
    let date: Date
}

struct ShareResponse: Decodable {
    let success: Bool
    let message: String
}
