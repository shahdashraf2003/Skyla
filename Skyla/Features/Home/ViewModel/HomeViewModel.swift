//
//  HomeViewModel.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//
import Foundation
import Combine
import CoreLocation


@MainActor
final class HomeViewModel: ObservableObject {

	let weatherRepository: WeatherRepositoryProtocol
	let locationService: LocationServiceProtocol
	let savedLocationRepository: SavedLocationRepositoryProtocol
	private let weatherContext: WeatherContext
	private let networkMonitor = NetworkMonitor.shared

	@Published private(set) var weather: WeatherResponse?
	@Published var state: ViewState = .loading
	@Published private(set) var isConnected = true
	@Published var selectedDay: ForecastDay?
	@Published var showSavedLocations = false
	@Published var allLocations: [SavedLocation] = []
	@Published var currentLocationIndex: Int = 0
	@Published private(set) var isTemporaryLocation = false

	private var currentGPSLocation: CLLocationCoordinate2D?
	private var isViewingSelectedLocation = false
	private var cancellables = Set<AnyCancellable>()
	private var fetchTask: Task<Void, Never>?

	init(
		weatherRepository: WeatherRepositoryProtocol,
		locationService: LocationServiceProtocol,
		savedLocationRepository: SavedLocationRepositoryProtocol,
		weatherContext: WeatherContext
	) {
		self.weatherRepository = weatherRepository
		self.locationService = locationService
		self.savedLocationRepository = savedLocationRepository
		self.weatherContext = weatherContext
		loadLocations()
		bindLocation()
		bindNetwork()
		bindAuthorization()
	}

	private func bindLocation() {
		locationService.locationPublisher
			.receive(on: DispatchQueue.main)
			.sink { [weak self] location in
				guard let self else { return }
				guard !self.isViewingSelectedLocation else { return }

				self.currentGPSLocation = location.coordinate
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
                print("Network Status:", connected)
				guard let self else { return }

				self.isConnected = connected

				if connected {
                    print("Internet Connected")
					if self.weather != nil {
						self.state = .loaded
					}
					if self.weather == nil,
					   let location = self.currentGPSLocation {
						self.fetchWeather(
							lat: location.latitude,
							lon: location.longitude
						)
					}
				} else {
                    print("Internet Disconnected")
					self.state = .noInternet
				}
			}
			.store(in: &cancellables)
	}

	func onAppear() {
		guard handleLocationAuthorization() else { return }
		guard !isViewingSelectedLocation else { return }

		if let location = currentGPSLocation {
			fetchWeather(lat: location.latitude, lon: location.longitude)
		} else {
			locationService.requestLocation()
		}
	}

	func checkLocationPermission() {
		guard handleLocationAuthorization() else { return }
		locationService.requestLocation()
	}

	func selectLocation(_ location: SavedLocation) {
		showSavedLocations = false
		isTemporaryLocation = false
		state = .loading
		if location.isCurrent {
			isViewingSelectedLocation = false
			currentGPSLocation = nil
			currentLocationIndex = 0

			if locationService.authorizationDenied {
				state = .locationDenied
				return
			}

			loadLocations()



			state = .loading
			locationService.requestLocation()
			return
		}

		isViewingSelectedLocation = true
		loadLocations()

		if let index = allLocations.firstIndex(where: {
			$0.lat == location.lat && $0.lon == location.lon
		}) {
			currentLocationIndex = index
		}

		fetchWeather(lat: location.lat, lon: location.lon, saveAsCurrent: false)
	}

	func viewWeather(lat: Double, lon: Double, name: String) {
		showSavedLocations = false
		isViewingSelectedLocation = true

		loadLocations()

		if let index = allLocations.firstIndex(where: {
			$0.lat == lat && $0.lon == lon
		}) {

			currentLocationIndex = index
			isTemporaryLocation = false
		} else {
			isTemporaryLocation = true
		}

		fetchWeather(lat: lat, lon: lon, saveAsCurrent: false)
	}

	func navigateToLocation(at index: Int) {
		guard allLocations.indices.contains(index) else { return }
		selectLocation(allLocations[index])
	}

	func refresh() async {
        
		if isViewingSelectedLocation {
			guard allLocations.indices.contains(currentLocationIndex) else { return }
			let location = allLocations[currentLocationIndex]
			fetchWeather(lat: location.lat, lon: location.lon, saveAsCurrent: false)
			return
		}

		if let location = currentGPSLocation {
			fetchWeather(lat: location.latitude, lon: location.longitude)
			return
		}

		await withCheckedContinuation { continuation in
			var resumed = false

			locationService.locationPublisher
				.first()
				.receive(on: DispatchQueue.main)
				.sink { [weak self] location in
					guard let self, !resumed else { return }
					resumed = true

					self.currentGPSLocation = location.coordinate
					self.fetchWeather(
						lat: location.coordinate.latitude,
						lon: location.coordinate.longitude
					)

					continuation.resume()
				}
				.store(in: &cancellables)

			locationService.requestLocation()
		}
	}

	func fetchWeather(lat: Double, lon: Double, saveAsCurrent: Bool = true) {
		fetchTask?.cancel()
		state = .loading

		fetchTask = Task {
			do {
				let weather = try await weatherRepository.getWeather(
					lat: lat,
					lon: lon,
					days: 3
				)
                print(lat , lon)
				guard !Task.isCancelled else { return }

				guard !weather.forecast.forecastday.isEmpty else {
					state = .empty
					return
				}

				self.weather = weather
				self.state = .loaded

				weatherContext.updateTime(weather.location.localtime)

				if saveAsCurrent {
					saveCurrentLocation(from: weather)
				}

			} catch {
				guard !Task.isCancelled else { return }

				if (error as? NetworkError) == .noInternet {
					state = .noInternet
				} else {
					state = .error(error.localizedDescription)
				}
			}
		}
	}

	func forceLocationRefresh() {
		currentGPSLocation = nil
		locationService.requestLocation()
	}

	private func handleLocationAuthorization() -> Bool {
		if locationService.authorizationDenied {
			state = .locationDenied
			return false
		}
		return true
	}

	func loadLocations() {
		allLocations = savedLocationRepository.getLocations()
	}

	private func saveCurrentLocation(from weather: WeatherResponse) {
		savedLocationRepository.saveCurrentLocation(
			name: weather.location.name,
			lat: weather.location.lat,
			lon: weather.location.lon
		)
		loadLocations()
	}

	func selectDay(_ row: ForecastRow) {
		selectedDay = row.day
	}

	var locationName: String {
		weather?.location.name ?? ""
	}

	var currentConditionIconURL: URL? {
		URLHelper.weatherIconURL(weather?.current.condition.icon)
	}

	var currentTemperature: String {
		guard let temp = weather?.current.tempC else { return "--" }
		return TemperatureFormatter.format(temp)
	}

	var conditionText: String {
		weather?.current.condition.text ?? "--"
	}

	var todayHighLow: String {
		guard let day = weather?.forecast.forecastday.first?.day else { return "--" }
		return TemperatureFormatter.range(min: day.mintempC, max: day.maxtempC)
	}

	var threeDayForecast: [ForecastRow] {
		guard let days = weather?.forecast.forecastday.prefix(3) else { return [] }

		return days.enumerated().map { index, day in
			ForecastRow(
				id: day.id,
				label: DateHelper.dayLabel(for: index),
				iconURL: URLHelper.weatherIconURL(day.day.condition.icon),
				range: "\(Int(day.day.mintempC))° - \(Int(day.day.maxtempC))°",
				day: day
			)
		}
	}

	var infoItems: [InfoItem] {
		guard let current = weather?.current else { return [] }
		return WeatherInfoMapper.map(from: current)
	}
}
