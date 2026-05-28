//
//  DateHelper.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//

import Foundation


struct DateHelper {

    static func dayLabel(for index: Int) -> String {
        switch index {
        case 0: return "Today"
        case 1: return "Tomorrow"
        default:
            let date = Calendar.current.date(byAdding: .day, value: index, to: Date()) ?? Date()
            let f = DateFormatter()
            f.dateFormat = "EEEE"
            return f.string(from: date)
        }
    }
}
