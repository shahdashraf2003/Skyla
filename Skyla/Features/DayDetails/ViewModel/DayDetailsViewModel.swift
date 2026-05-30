//
//  DetailsOfDayViewModel.swift
//  Skyla
//
//  Created by Shahudaa on 29/05/2026.
//

import Foundation
import Combine

@MainActor
final class DayDetailsViewModel: ObservableObject {

	let day: ForecastDay

	init(day: ForecastDay) {
		self.day = day
	}

	var hourlyForecast: [HourWeather] {
		let hours = day.hour

		let now = Calendar.current.component(.hour, from: Date())

		return hours.filter {
			let date = DateHelper.parseDate($0.time)
			let hour = Calendar.current.component(.hour, from: date)
			return hour >= now
		}
	}
	var groupedHours: [[HourWeather]] {
		let filtered = hourlyForecast

		return stride(from: 0, to: filtered.count, by: 3).map { index in
			Array(filtered[index..<min(index + 3, filtered.count)])
		}
	}

	var date: String {
		day.date
	}

	var conditionText: String {
		day.day.condition.text
	}

	var iconURL: URL? {
		URLHelper.weatherIconURL(day.day.condition.icon)
	}

	var rangeTemp: String {
		TemperatureFormatter.range(min: day.day.mintempC, max: day.day.maxtempC)
	}


	var theme: WeatherTheme {
		ThemeHelper.currentTheme()
	}

	var backgroundImageName: String {
		theme.backgroundImage
	}

	



}
