//
//  DayForecast.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//


struct Forecast: Codable {

	let forecastday: [ForecastDay]
}

struct ForecastDay: Codable, Identifiable {

	let date: String
	let day: DayForecast
	let hour: [HourWeather]
	var id: String {
		date
	}
}


struct DayForecast: Codable {

	let maxtempC: Double
	let mintempC: Double
	let avgtempC: Double
	let condition: WeatherCondition

	enum CodingKeys: String, CodingKey {

		case maxtempC = "maxtemp_c"
		case mintempC = "mintemp_c"
		case avgtempC = "avgtemp_c"
		case condition
	}
}
