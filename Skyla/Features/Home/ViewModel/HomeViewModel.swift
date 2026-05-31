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
	let savedLocationRepository: SavedLocationRepositoryProtocol
	private var cancellables = Set<AnyCancellable>()
	private let networkMonitor = NetworkMonitor.shared
	private var fetchTask: Task<Void, Never>?
	private var currentGPSLocation: CLLocationCoordinate2D?
	private var isViewingSelectedLocation = false
	
	@Published private(set) var weather: WeatherResponse?
	@Published var state: ViewState = .loading
	@Published private(set) var isConnected = true
	@Published private(set) var isShowingCachedData = false
	@Published var selectedDay: ForecastDay?
	@Published var showSavedLocations = false
	
	@Published var allLocations: [SavedLocation] = []
	@Published var currentLocationIndex: Int = 0
	private let weatherContext: WeatherContext
	@Published private(set) var weatherByLocation: [UUID: WeatherResponse] = [:]

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
		print("VM Context:", ObjectIdentifier(weatherContext))



	}
	


	private func bindLocation() {
		locationService.locationPublisher
			.receive(on: DispatchQueue.main)
			.sink { [weak self] location in
				guard let self else { return }
				guard !self.isViewingSelectedLocation else { return }
				print("Location received:", location.coordinate)
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
				if denied { self.state = .locationDenied }
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
				   let location = self.currentGPSLocation {

					self.fetchWeather(
						lat: location.latitude,
						lon: location.longitude
					)
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

		if let index = allLocations.firstIndex(where: { $0.id == location.id }) {
			currentLocationIndex = index
		}

		if location.isCurrent {
			isViewingSelectedLocation = false
			currentGPSLocation = nil
			locationService.requestLocation()
			return
		}
		isViewingSelectedLocation = true

		fetchWeather(
			lat: location.lat,
			lon: location.lon,
			saveAsCurrent: false
		)
	}

	func refresh() async {
		guard isConnected else {
			isShowingCachedData = true
			return
		}
		
		if isViewingSelectedLocation {

			guard allLocations.indices.contains(currentLocationIndex) else {
				return
			}

			let location = allLocations[currentLocationIndex]
			
			fetchWeather(
				lat: location.lat,
				lon: location.lon,
				saveAsCurrent: false
			)

			return
		}

		if let location = currentGPSLocation {

			fetchWeather(
				lat: location.latitude,
				lon: location.longitude
			)

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
					self.fetchWeather(lat: location.coordinate.latitude,
									  lon: location.coordinate.longitude)
					continuation.resume()
				}
				.store(in: &cancellables)
			locationService.requestLocation()
		}
	}
	
	
	func fetchWeather(lat: Double, lon: Double, saveAsCurrent: Bool = true) {
		fetchTask?.cancel()
		if weather == nil { state = .loading }
		
		fetchTask = Task {
			do {
				let result = try await weatherRepository.getWeather(
					lat: lat, lon: lon, days: 3
				)
				guard !Task.isCancelled else { return }
				guard !result.0.forecast.forecastday.isEmpty else {
					state = .empty
					return
				}
				
				weather = result.0
				if allLocations.indices.contains(currentLocationIndex) {
					let locationId = allLocations[currentLocationIndex].id
					weatherByLocation[locationId] = result.0
				}
				isShowingCachedData = result.1
				state = .loaded
				weatherContext.updateTime(result.0.location.localtime)
				print(weatherContext.theme)
				print(allLocations.count)
				if saveAsCurrent {
					saveCurrentLocation(from: result.0)
				}
				
			} catch {
				guard !Task.isCancelled else { return }
				state = .error(error.localizedDescription)
			}
		}
	}
	func forceLocationRefresh() {
		currentGPSLocation = nil
		locationService.requestLocation()
	}

	
	var locationName: String {
		weather?.location.name ?? ""
	}
	
	var currentConditionIconURL: URL? {
		makeIconURL(from: weather?.current.condition.icon)
	}
	
	var currentTemperature: String {
		guard let temperature = weather?.current.tempC else { return "--" }
		return TemperatureFormatter.format(temperature)
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
				label: label(forIndex: index),
				iconURL: makeIconURL(from: day.day.condition.icon),
				range: "\(Int(day.day.mintempC))° - \(Int(day.day.maxtempC))°",
				day: day
			)
		}
	}
	
	var infoItems: [InfoItem] {
		guard let current = weather?.current else { return [] }
		return WeatherInfoMapper.map(from: current)
	}
	
	func selectDay(_ row: ForecastRow) {
		selectedDay = row.day
	}
	
	private func handleLocationAuthorization() -> Bool {
		if locationService.authorizationDenied {
			state = .locationDenied
			return false
		}
		return true
	}
	
	private func label(forIndex index: Int) -> String {
		DateHelper.dayLabel(for: index)
	}
	
	private func makeIconURL(from icon: String?) -> URL? {
		URLHelper.weatherIconURL(icon)
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
	
	
	
	func navigateToLocation(at index: Int) {

		guard allLocations.indices.contains(index) else {
			return
		}

		selectLocation(allLocations[index])
	}
}
