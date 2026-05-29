//
//  HomeViewModel.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//
import Foundation
import SwiftUI
internal import Combine
internal import _LocationEssentials

@MainActor
final class HomeViewModel: ObservableObject {

	let weatherRepository: WeatherRepositoryProtocol
	let locationService: LocationServiceProtocol
	private var cancellables = Set<AnyCancellable>()

	@Published private(set) var weather: WeatherResponse?
	@Published var state: ViewState = .loading
	@Published private(set) var isConnected = true
	@Published private(set) var isShowingCachedData = true

	private var lastLat: Double?
	private var lastLon: Double?

	private let networkMonitor = NetworkMonitor.shared

	init(
		weatherRepository: WeatherRepositoryProtocol,
		locationService: LocationServiceProtocol
	) {
		self.weatherRepository = weatherRepository
		self.locationService = locationService
		bindLocation()
		bindNetwork()
		bindAuthorization()
	}

	private func bindLocation() {
		locationService.locationPublisher
			.receive(on: DispatchQueue.main)
			.sink { [weak self] location in

				self?.lastLat = location.coordinate.latitude
				self?.lastLon = location.coordinate.longitude

				self?.fetchWeather(
					lat: location.coordinate.latitude,
					lon: location.coordinate.longitude
				)
			}
			.store(in: &cancellables)
	}

	func checkLocationPermission() {

		if locationService.authorizationDenied {

			state = .locationDenied

		} else {

			locationService.requestLocation()
		}
	}
	private func bindAuthorization() {

		locationService.authorizationStatusPublisher
			.receive(on: DispatchQueue.main)
			.sink { [weak self] denied in

				if denied {
					self?.state = .locationDenied
				}
			}
			.store(in: &cancellables)
	}

	

	func onAppear() {

		if locationService.authorizationDenied {
			state = .locationDenied
			return
		}

		if let lat = lastLat,
		   let lon = lastLon {
			fetchWeather(lat: lat, lon: lon)

		} else {
			locationService.requestLocation()
		}
	}

	func fetchWeather(lat: Double, lon: Double) {
		state = .loading

		Task {
			do {
				let result = try await weatherRepository.getWeather(
					lat: lat,
					lon: lon,
					days: 3
				)

				guard !result.0.forecast.forecastday.isEmpty else {
					state = .empty
					return
				}

				weather = result.0
				isShowingCachedData = result.1
				state = .loaded

			} catch {
				state = .error(error.localizedDescription)
			}
		}
	}

	func refresh() {
		if !isConnected {
			isShowingCachedData = true
			return
		}

		locationService.requestLocation()
		print("refreshing")
	}


	private func bindNetwork() {
		networkMonitor.$isConnected
			.receive(on: DispatchQueue.main)
			.removeDuplicates()
			.sink { [weak self] connected in
				guard let self else { return }
				self.isConnected = connected

				if connected {
					if self.weather == nil,
					   let lat = self.lastLat, let lon = self.lastLon {
						self.fetchWeather(lat: lat, lon: lon)
					}
				}
			}
			.store(in: &cancellables)
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

	var conditionText: String { weather?.current.condition.text ?? "--" }

	var todayHighLow: String {
		guard let day = weather?.forecast.forecastday.first?.day else { return "--" }
		return TemperatureFormatter.range(min: day.mintempC, max: day.maxtempC)
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

	var infoItems: [InfoItem] {
		guard let c = weather?.current else { return [] }
		return WeatherInfoMapper.map(from: c)
	}


	private func label(forIndex index: Int) -> String {
		DateHelper.dayLabel(for: index)
	}

	private func iconURL(_ icon: String?) -> URL? {
		guard let icon else { return nil }
		return URLHelper.weatherIconURL(icon)
	}
}
