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

	let localTime: String?
	let day: ForecastDay

	init(day: ForecastDay,localTime :String) {
		self.day = day
		self.localTime = localTime
		print("day.date =", day.date)
		print("parsed =", DateHelper.parseDayDate(day.date))
		print("today =", Date())
		print("isToday =", isToday)

	}
	var isEmpty: Bool {
		hourlyForecast.isEmpty
	}

	private var isToday: Bool {

		guard let currentLocationDate =
				WeatherTimeProvider(localTime: localTime).date
		else {
			return false
		}

		let forecastDate = Calendar.current.startOfDay(
			for: DateHelper.parseDayDate(day.date)
		)

		let currentDate = Calendar.current.startOfDay(
			for: currentLocationDate
		)

		return forecastDate == currentDate
	}

	private var currentHour: Int {
		WeatherTimeProvider(
			localTime: localTime
		).hour
	}
	var hourlyForecast: [HourWeather] {

		let cleaned = removeDuplicates(from: day.hour)

		guard isToday else {
			return cleaned
		}

		let nowHour = currentHour

		return cleaned.filter { hour in
			let date = DateHelper.parseDateTime(hour.time)
			let hourValue = Calendar.current.component(.hour, from: date)

			return hourValue >= nowHour
		}
	}

	var hourlyUI: [HourUIModel] {

		return hourlyForecast.map { hour in

			let date = DateHelper.parseDateTime(hour.time)
			let hourValue = Calendar.current.component(.hour, from: date)

			let isNow = isToday && hourValue == currentHour

			return HourUIModel(
				hour: hour,
				isNow: isNow,
				displayTitle: isNow
				? "Now"
				: DateHelper.formatTime(hour.time)
			)
		}
	}


	var groupedHours: [[HourUIModel]] {

		let hours = hourlyUI

		return stride(from: 0, to: hours.count, by: 3).map { index in
			Array(hours[index..<min(index + 3, hours.count)])
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
		TemperatureFormatter.range(
			min: day.day.mintempC,
			max: day.day.maxtempC
		)
	}


	
	private func removeDuplicates(from hours: [HourWeather]) -> [HourWeather] {

		var seen = Set<String>()

		return hours.filter { hour in
			let key = hour.time
			guard !seen.contains(key) else { return false }
			seen.insert(key)
			return true
		}
	}
}
