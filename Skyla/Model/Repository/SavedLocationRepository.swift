//
//  SavedLocationRepository.swift
//  Skyla
//
//  Created by Shahudaa on 30/05/2026.
//
protocol SavedLocationRepositoryProtocol {
	func getLocations() -> [SavedLocation]
	func addLocation(_ location: SavedLocation)
	func deleteLocation(_ location: SavedLocation)
	func saveCurrentLocation(name: String, lat: Double, lon: Double)
}

final class SavedLocationRepository: SavedLocationRepositoryProtocol {

    private let service: SavedLocationServiceProtocol

    init(service: SavedLocationServiceProtocol) {
        self.service = service
    }

    func getLocations() -> [SavedLocation] {
        service.fetch()
    }

    func addLocation(_ location: SavedLocation) {
        service.add(location)
    }

    func deleteLocation(_ location: SavedLocation) {
        service.delete(location)
    }
	func saveCurrentLocation(name: String, lat: Double, lon: Double) {

		service.saveCurrentLocation(name: name, lat: lat, lon: lon)
	}
}
