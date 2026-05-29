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



	static func formatTime(_ string: String) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm"

		guard let date = formatter.date(from: string) else {
			return string
		}

		let output = DateFormatter()
		output.dateFormat = "h a"
		return output.string(from: date)
	}




		static func parseDayDate(_ string: String) -> Date {
			let formatter = DateFormatter()
			formatter.dateFormat = "yyyy-MM-dd"
			return formatter.date(from: string) ?? Date.distantPast
		}

		static func parseDateTime(_ string: String) -> Date {
			let formatter = DateFormatter()
			formatter.dateFormat = "yyyy-MM-dd HH:mm"
			return formatter.date(from: string) ?? Date.distantPast
		}


}
