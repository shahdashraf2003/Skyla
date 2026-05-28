//
//  WeatherRepository.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//

protocol WeatherRepositoryProtocol {
	func getWeather(lat: Double, lon: Double, days: Int) async throws -> WeatherResponse
}

final class WeatherRepository: WeatherRepositoryProtocol {

    private let waetherService: WeatherServiceProtocol

	private let locationService :  any LocationServiceProtocol

	init(
		waetherService: WeatherServiceProtocol,
		locationService:  any LocationServiceProtocol
	) {
        self.waetherService = waetherService
		self.locationService = locationService
    }

    func getWeather(lat: Double, lon: Double, days: Int) async throws -> WeatherResponse {
        return try await waetherService.getForecast(lat: lat, lon: lon, days: days)
    }
}
