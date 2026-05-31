//
//  ExploreCitysViewModel.swift
//  Skyla
//
//  Created by Shahudaa on 31/05/2026.
//


import Foundation
import Combine

final class ExploreLocationsViewModel: ObservableObject {

    @Published var query: String = ""
    @Published var results: [City] = []
    @Published var suggested: [City] = []

    private var cancellables = Set<AnyCancellable>()
	private let repository: WeatherRepositoryProtocol

	init(repository: WeatherRepositoryProtocol) {
        self.repository = repository
        setupBindings()
        
    }

    private func setupBindings() {

		$query
			.removeDuplicates()
			.debounce(for: .milliseconds(400),
					  scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                self?.search(text)
            }
            .store(in: &cancellables)

		print(query)
    }

    private func search(_ text: String) {
        guard !text.isEmpty else {
            results = []
            return
        }

		Task {
			do {
				let data = try await repository.searchCities(query: text)

				await MainActor.run {
					self.results = data
				}
			} catch {
				print(error)
			}
		}
    }


}
