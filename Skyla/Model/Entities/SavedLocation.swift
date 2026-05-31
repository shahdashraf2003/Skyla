//
//  SavedLocation.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//

import Foundation
import SwiftData

@Model
final class SavedLocation {
	var id: UUID
	var name: String
	var lat: Double
	var lon: Double
	var isSelected: Bool
	var isCurrent :Bool
	init(name: String, lat: Double, lon: Double, isSelected: Bool = false ,isCurrent: Bool = false) {
		self.id = UUID()
		self.name = name
		self.lat = lat
		self.lon = lon
		self.isSelected = isSelected
		self.isCurrent = isCurrent
	}
}
