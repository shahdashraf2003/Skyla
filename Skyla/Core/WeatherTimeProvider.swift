//
//  WeatherTimeProvider.swift
//  Skyla
//
//  Created by Shahudaa on 30/05/2026.
//

import Foundation


struct WeatherTimeProvider {
    let localTime: String?

    var hour: Int {
        guard let localTime else { return Calendar.current.component(.hour, from: Date()) }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        guard let date = formatter.date(from: localTime) else {
            return Calendar.current.component(.hour, from: Date())
        }

        return Calendar.current.component(.hour, from: date)
    }

	var date: Date? {
		guard let localTime else { return nil }

		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm"

		return formatter.date(from: localTime)
	}
}
