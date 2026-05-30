//
//  SavedLocationsViewModel.swift
//  Skyla
//
//  Created by Shahudaa on 30/05/2026.
//


import SwiftData
import Combine

@MainActor
final class SavedLocationsViewModel: ObservableObject {

	private let repo: SavedLocationRepositoryProtocol

	@Published var locations: [SavedLocation] = []

	init(repo: SavedLocationRepositoryProtocol) {
		self.repo = repo
		load()
	}

	func load() {
		locations = repo.getLocations()
	}

	func add(name: String, lat: Double, lon: Double) {
		repo.addLocation(SavedLocation(name: name, lat: lat, lon: lon))
		load()
	}

	func delete(_ item: SavedLocation) {
		repo.deleteLocation(item)
		load()
	}
}
