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
	@Published var showAddLocation = false
	init(repo: SavedLocationRepositoryProtocol) {
		self.repo = repo
		load()
	}

	func load() {
		locations = repo.getLocations()
	}


	func delete(_ item: SavedLocation) {
		repo.deleteLocation(item)
		load()
	}
	var theme: WeatherTheme {
		ThemeHelper.currentTheme()
	}

	var backgroundImageName: String {
		theme.backgroundImage
	}
}
