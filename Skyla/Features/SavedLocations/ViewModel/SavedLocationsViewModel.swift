//
//  SavedLocationsViewModel.swift
//  Skyla
//
//  Created by Shahudaa on 30/05/2026.
//


import Combine

@MainActor
final class SavedLocationsViewModel: ObservableObject {

    private let repo: SavedLocationRepositoryProtocol

    @Published var locations: [SavedLocation] = []
    @Published var navigateToExplore = false

    init(repo: SavedLocationRepositoryProtocol) {
        self.repo = repo
        load()
    }

    var isEmpty: Bool {
        locations.isEmpty
    }

    func load() {
        locations = repo.getLocations()
    }

    func delete(_ item: SavedLocation) {
        repo.deleteLocation(item)
        load()
    }

    func addTapped() {
        navigateToExplore = true
    }

    func selectLocation(_ location: SavedLocation) {}

    func buildSavedLocation(from city: City) -> SavedLocation {
        SavedLocation(
            name: city.name,
            lat: city.lat,
            lon: city.lon,
            isCurrent: false
        )
    }
}
