//
//  Date+DateFormatter.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2025-09-01.
//

import Foundation

extension Date {
    private static let mmddyyyyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yyyy"
        return formatter
    }()

    func formattedMMddyyyy() -> String {
        Self.mmddyyyyFormatter.string(from: self)
    }
}
