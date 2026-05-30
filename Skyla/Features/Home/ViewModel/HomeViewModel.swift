//
//  HomeViewModel.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//
import Foundation
import Combine
import _LocationEssentials

@MainActor
final class HomeViewModel: ObservableObject {

	let weatherRepository: WeatherRepositoryProtocol
	let locationService: LocationServiceProtocol
	private var cancellables = Set<AnyCancellable>()
	private let networkMonitor = NetworkMonitor.shared
	private var fetchTask: Task<Void, Never>?
	private var lastLocation: CLLocationCoordinate2D?
	@Published private(set) var weather: WeatherResponse?
	@Published var state: ViewState = .loading
	@Published private(set) var isConnected = true
	@Published private(set) var isShowingCachedData = false

	@Published var selectedDay: ForecastDay?
	@Published var showSavedLocations = false

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
				guard let self else { return }
				self.lastLocation = location.coordinate
				self.fetchWeather(
					lat: location.coordinate.latitude,
					lon: location.coordinate.longitude
				)
			}
			.store(in: &cancellables)
	}

	private func bindAuthorization() {
		locationService.authorizationStatusPublisher
			.receive(on: DispatchQueue.main)
			.sink { [weak self] denied in
				guard let self else { return }
				if denied {
					self.state = .locationDenied
				}
			}
			.store(in: &cancellables)
	}

	private func bindNetwork() {
		networkMonitor.$isConnected
			.receive(on: DispatchQueue.main)
			.removeDuplicates()
			.sink { [weak self] connected in
				guard let self else { return }

				self.isConnected = connected

				if connected,
				   self.weather == nil,
				   let location = self.lastLocation {

					self.fetchWeather(
						lat: location.latitude,
						lon: location.longitude
					)
				}
			}
			.store(in: &cancellables)
	}

	private func handleLocationAuthorization() -> Bool {
		if locationService.authorizationDenied {
			state = .locationDenied
			return false
		}

		return true
	}

	func checkLocationPermission() {
		guard handleLocationAuthorization() else { return }
		locationService.requestLocation()
	}



	func onAppear() {

		guard handleLocationAuthorization() else { return }
		if let location = lastLocation {
			fetchWeather(
				lat: location.latitude,
				lon: location.longitude
			)

		} else {
			locationService.requestLocation()
		}
	}

	func fetchWeather(lat: Double, lon: Double) {

		fetchTask?.cancel()
		if weather == nil {
			state = .loading
		}

		fetchTask = Task {
			do {
				let result = try await weatherRepository.getWeather(
					lat: lat,
					lon: lon,
					days: 3
				)

				guard !Task.isCancelled else { return }
				guard !result.0.forecast.forecastday.isEmpty else {
					state = .empty
					return
				}

				weather = result.0
				isShowingCachedData = result.1
				state = .loaded

			} catch {
				guard !Task.isCancelled else { return }
				state = .error(error.localizedDescription)
			}
		}
	}

	func refresh() {
		guard isConnected else {
			isShowingCachedData = true
			return
		}

		locationService.requestLocation()
	}

	var theme: WeatherTheme {
		ThemeHelper.currentTheme()
	}

	var backgroundImageName: String {
		theme.backgroundImage
	}


	var locationName: String {
		weather?.location.name ?? ""
	}

	var currentConditionIconURL: URL? {
		makeIconURL(from: weather?.current.condition.icon)
	}

	var currentTemperature: String {

		guard let temperature = weather?.current.tempC else {
			return "--"
		}

		return TemperatureFormatter.format(temperature)
	}

	var conditionText: String {
		weather?.current.condition.text ?? "--"
	}

	var todayHighLow: String {

		guard let day = weather?.forecast.forecastday.first?.day else {
			return "--"
		}

		return TemperatureFormatter.range(
			min: day.mintempC,
			max: day.maxtempC
		)
	}

	var threeDayForecast: [ForecastRow] {

		guard let days = weather?.forecast.forecastday.prefix(3) else {
			return []
		}

		return days.enumerated().map { index, day in
			ForecastRow(
				id: day.id,
				label: label(forIndex: index),
				iconURL: makeIconURL(from: day.day.condition.icon),
				range: "\(Int(day.day.mintempC))° - \(Int(day.day.maxtempC))°",
				day: day
			)
		}
	}
	func selectDay(_ row: ForecastRow) {
		selectedDay = row.day
	}

	var infoItems: [InfoItem] {

		guard let current = weather?.current else {
			return []
		}
		return WeatherInfoMapper.map(from: current)
	}


	private func label(forIndex index: Int) -> String {
		DateHelper.dayLabel(for: index)
	}

	private func makeIconURL(from icon: String?) -> URL? {
		return URLHelper.weatherIconURL(icon)
	}
}
