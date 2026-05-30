//
//  HourUIModel.swift
//  Skyla
//
//  Created by Shahudaa on 29/05/2026.
//

import Foundation


struct HourUIModel: Identifiable {
	let id = UUID()
	let hour: String
	let temp: String
	let iconURL: URL?
	let isHighlighted: Bool
}
