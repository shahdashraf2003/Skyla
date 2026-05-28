//
//  CurrentWeather.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//

struct CurrentWeather: Codable {

	let tempC: Double
	let feelslikeC: Double
	let humidity: Int
	let pressureMb: Double
	let visKm: Double
	let uv: Double
	let windKph: Double
	let windDir: String
	let lastUpdated: String
	let isDay: Int
	let condition: WeatherCondition
	enum CodingKeys: String, CodingKey {

		case tempC = "temp_c"
		case feelslikeC = "feelslike_c"
		case humidity
		case pressureMb = "pressure_mb"
		case visKm = "vis_km"
		case uv
		case windKph = "wind_kph"
		case windDir = "wind_dir"
		case lastUpdated = "last_updated"
		case isDay = "is_day"
		case condition
	}
}
