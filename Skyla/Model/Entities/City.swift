//
//  City.swift
//  Skyla
//
//  Created by Shahudaa on 31/05/2026.
//

import Foundation

struct City: Codable, Identifiable,Equatable {
	var id  : Int
	let name: String
	let region: String
	let country: String
	let lat: Double
	let lon: Double
}
