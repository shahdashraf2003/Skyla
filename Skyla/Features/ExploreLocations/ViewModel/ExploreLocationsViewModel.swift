//
//  ExploreCitysViewModel.swift
//  Skyla
//
//  Created by Shahudaa on 31/05/2026.
//
//
//  ExploreLocationsViewModel.swift
//  Skyla
//

import Foundation
import Combine

final class ExploreLocationsViewModel: ObservableObject {

	
	@Published var query: String = ""


	@Published var results: [City] = []
	@Published var suggested: [String] = []

	private var cancellables = Set<AnyCancellable>()
	private let repository: WeatherRepositoryProtocol


	init(repository: WeatherRepositoryProtocol) {
		self.repository = repository
		setupBindings()
		loadSuggested()
	}


	private func loadSuggested() {
		suggested = SuggestedCities.cities
	}


	private func setupBindings() {

		$query
			.debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
			.removeDuplicates()
			.sink { [weak self] text in
				self?.search(text)
			}
			.store(in: &cancellables)
	}


	private func search(_ text: String) {

		let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)

		guard !trimmed.isEmpty else {
			results = []
			return
		}

		Task {
			do {
				let data = try await repository.searchCities(query: trimmed)

				await MainActor.run {
					self.results = data
				}

			} catch {
				print("Search error:", error)
			}
		}
	}


	func select(_ city: City) {
		query = city.name
		results = []
	}


	func selectSuggested(_ city: City) {
		query = city.name

		Task {
			do {
				let data = try await repository.searchCities(query: city.name)

				await MainActor.run {
					self.results = data
					self.suggested = SuggestedCities.cities
				}

			} catch {
				print("Error selecting suggested:", error)
			}
		}
	}
}
