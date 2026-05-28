//
//  HomeViewModel.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//
import Foundation
import SwiftUI
internal import Combine

@MainActor
final class HomeViewModel: ObservableObject {

	private let weatherRepository: WeatherRepositoryProtocol

	@Published private(set) var weather: WeatherResponse?
	@Published private(set) var isLoading: Bool = false
	@Published private(set) var errorMessage: String?

	init(weatherRepository: WeatherRepositoryProtocol) {
		self.weatherRepository = weatherRepository
	}

	func fetchWeather(lat: Double, lon: Double) {
		isLoading = true
		errorMessage = nil
		Task {
			do {
				let result = try await weatherRepository.getWeather(lat: lat, lon: lon, days: 3)
				self.weather = result
				self.isLoading = false
			} catch {
				self.errorMessage = error.localizedDescription
				self.isLoading = false
			}
		}
	}

	var theme: WeatherTheme {
		ThemeHelper.currentTheme()
	}

	var backgroundImageName: String { theme.backgroundImage }

	var foregroundColor: Color { theme == .day ? .black : .white }

	var locationName: String {
		weather?.location.name ?? ""
	}

	var currentConditionIconURL: URL? {
		URLHelper.weatherIconURL(weather?.current.condition.icon)
	}

	var currentTemperature: String {
		guard let t = weather?.current.tempC else { return "--" }
		return TemperatureFormatter.format(t)
	}

	var conditionText: String { weather?.current.condition.text ?? "--"  }



	var todayHighLow: String {
		guard let day = weather?.forecast.forecastday.first?.day else { return "--"  }
		return TemperatureFormatter.range(min: day.mintempC, max: day.maxtempC)
	}

	struct ForecastRow: Identifiable {
		let id: String
		let label: String
		let iconURL: URL?
		let range: String
	}

	var threeDayForecast: [ForecastRow] {
		guard let days = weather?.forecast.forecastday.prefix(3) else { return [] }
		return days.enumerated().map { index, day in
			ForecastRow(
				id: day.id,
				label: label(forIndex: index),
				iconURL: iconURL(day.day.condition.icon),
				range: "\(Int(day.day.mintempC))° - \(Int(day.day.maxtempC))°"
			)
		}
	}

	struct InfoItem: Identifiable {
		let id = UUID()
		let title: String
		let value: String
	}


	var infoItems: [InfoItem] {
		guard let c = weather?.current else { return [] }
		 return WeatherInfoMapper.map(from: c)
	}

	private func label(forIndex index: Int) -> String {
		return DateHelper.dayLabel(for: index)
	}

	private func iconURL(_ icon: String?) -> URL? {
		guard let icon else { return nil }
		return URLHelper.weatherIconURL(icon)
	}
}
