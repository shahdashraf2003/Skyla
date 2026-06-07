//
//  WeatherService.swift
//  Skyla
//
//  Created by Shahd Ashraf 28/05/2026.
//
import Foundation

protocol WeatherServiceProtocol {
	func getForecast(lat: Double, lon: Double, days: Int) async throws -> WeatherResponse
	func searchCities(query: String) async throws -> [City]
}



final class WeatherService: WeatherServiceProtocol {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func getForecast(lat: Double, lon: Double, days: Int) async throws -> WeatherResponse{
        return try await apiClient.request(.forecast(lat: lat, lon: lon, days: days))
    }

	func searchCities(query: String) async throws -> [City] {
			return try await apiClient.request(.search(query: query))
		}

}
