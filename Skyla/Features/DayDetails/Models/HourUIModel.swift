//
//  HourUIModel.swift
//  Skyla
//
//  Created by Shahudaa on 29/05/2026.
//

import Foundation

struct HourUIModel: Identifiable {
	let id = UUID()
	let hour: HourWeather
	let isNow: Bool
	let displayTitle: String
}

