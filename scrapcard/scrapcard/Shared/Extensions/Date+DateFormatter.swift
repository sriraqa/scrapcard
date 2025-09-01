//
//  Date+DateFormatter.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2025-09-01.
//

import Foundation

extension Date {
    func formattedMMddyyyy() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yyyy"
        return formatter.string(from: self)
    }
}
