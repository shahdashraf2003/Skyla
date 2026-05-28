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

    private let service: WeatherServiceProtocol

    init(service: WeatherServiceProtocol) {
        self.service = service
    }

    func getWeather(lat: Double, lon: Double, days: Int) async throws -> WeatherResponse {
        return try await service.getForecast(lat: lat, lon: lon, days: days)
    }
}
