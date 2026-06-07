//
//  HourWeather.swift
//  Skyla
//
//  Created by Shahd Ashraf  on 28/05/2026.
//


import Foundation
struct HourWeather: Codable, Identifiable ,Hashable {

	let timeEpoch: Int
	let time: String
	let tempC: Double
	let chanceOfRain: Int
	let windKph: Double
	let condition: WeatherCondition

	var id: Int {
		timeEpoch
	}
	var hourText: String {

		let components = time.components(separatedBy: " ")
		return components.last ?? time
	}

	enum CodingKeys: String, CodingKey {

		case timeEpoch = "time_epoch"
		case time
		case tempC = "temp_c"
		case chanceOfRain = "chance_of_rain"
		case windKph = "wind_kph"
		case condition
	}
}


