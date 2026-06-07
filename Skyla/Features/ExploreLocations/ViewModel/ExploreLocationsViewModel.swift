//
//  ExploreCitysViewModel.swift
//  Skyla
//
//  Created by Shahudaa on 31/05/2026.
//
//
import Foundation
import Combine

final class ExploreLocationsViewModel: ObservableObject {

    @Published var query: String = ""
    @Published var results: [City] = []
    @Published var suggested: [String] = []
    @Published var selectedCity: City?
    @Published var showAddAlert = false
    @Published var isLoadingCity = false
    @Published var shouldDismiss = false
    @Published var isSearching = false
    @Published var showNoResults = false
    @Published var showNoInternet = false

    private var cancellables = Set<AnyCancellable>()
    private let repository: WeatherRepositoryProtocol
    private let savedLocationRepository: SavedLocationRepositoryProtocol
    private let weatherContext: WeatherContext

    var onAddToSaved: ((City) -> Void)?
    var onViewWeather: ((City, Location) -> Void)?
    private var selectedLocation: Location?

    init(
        repository: WeatherRepositoryProtocol,
        savedLocationRepository: SavedLocationRepositoryProtocol,
        weatherContext: WeatherContext
    ) {
        self.repository = repository
        self.savedLocationRepository = savedLocationRepository
        self.weatherContext = weatherContext
        setupBindings()
        loadSuggested()
    }

    func selectCity(_ city: City) {
        selectedCity = city
        fetchLocationDetails(for: city)
    }

	func retrySearch() async {

		if let name = pendingSuggestedName {
			await MainActor.run { showNoInternet = false }
			selectSuggestedByName(name)
			return
		}

		let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
		guard !trimmed.isEmpty else { return }
		await MainActor.run { showNoInternet = false }
		await performSearch(trimmed)
	}

    private func fetchLocationDetails(for city: City) {
        isLoadingCity = true
        Task {
            do {
                let weather = try await repository.getWeather(lat: city.lat, lon: city.lon, days: 1)
                await MainActor.run {
                    self.selectedLocation = weather.location
                    self.isLoadingCity = false
                    self.showAddAlert = true
                }
            } catch {
                await MainActor.run {
                    self.isLoadingCity = false
                    self.showAddAlert = true
                }
                print("Error fetching location details:", error)
            }
        }
    }

    func confirmAddToSaved() {
        guard let city = selectedCity else { return }
        let location = SavedLocation(name: city.name, lat: city.lat, lon: city.lon, isCurrent: false)
        savedLocationRepository.addLocation(location)
        onAddToSaved?(city)
        
    }

    func confirmViewWeather() {
        guard let city = selectedCity, let location = selectedLocation else { return }
        weatherContext.updateTime(location.localtime)
        onViewWeather?(city, location)
       
    }

	private var pendingSuggestedName: String?

	func selectSuggestedByName(_ name: String) {
		pendingSuggestedName = name
		Task {
			do {
				let data = try await repository.searchCities(query: name)
				await MainActor.run {
					if let first = data.first {
						self.results = data
						self.query = name
						self.selectCity(first)
					}
				}
			} catch {
				await MainActor.run {
					if case NetworkError.noInternet = error {
						self.showNoInternet = true
					}
				}
			}
		}
	}


    private func loadSuggested() {
        suggested = SuggestedCities.cities
    }

    private func setupBindings() {
        $query
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                guard let self else { return }
                let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmed.isEmpty {
                    self.results = []
                    self.showNoResults = false
                    self.showNoInternet = false
                    self.isSearching = false
                } else {
                    self.isSearching = true
                    self.showNoResults = false
                    self.showNoInternet = false
                    Task { await self.performSearch(trimmed) }
                }
            }
            .store(in: &cancellables)
    }

    private func performSearch(_ text: String) async {
        do {
            let data = try await repository.searchCities(query: text)
            await MainActor.run {
                self.isSearching = false
                self.results = data
                self.showNoResults = data.isEmpty
            }
        } catch {
            await MainActor.run {
                self.isSearching = false
                self.results = []
                if case NetworkError.noInternet = error {
                    self.showNoInternet = true
                } else {
                    self.showNoResults = true
                }
            }
            print("Search error:", error)
        }
    }
}
