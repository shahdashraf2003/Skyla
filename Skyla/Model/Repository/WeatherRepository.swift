//
//  WeatherRepository.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//

protocol WeatherRepositoryProtocol {
	func getWeather(lat: Double, lon: Double, days: Int) async throws -> WeatherResponse
	func searchCities(query: String) async throws -> [City]
}

final class WeatherRepository: WeatherRepositoryProtocol {

	private let service: WeatherServiceProtocol

	init(service: WeatherServiceProtocol) {
		self.service = service
	}

	func getWeather(lat: Double, lon: Double, days: Int) async throws -> WeatherResponse {
		try await service.getForecast(lat: lat, lon: lon, days: days)
	}

	func searchCities(query: String) async throws -> [City] {
		try await service.searchCities(query: query)
	}
}
