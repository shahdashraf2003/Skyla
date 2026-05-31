//
//  AppViewModelFactory.swift
//  Skyla
//
//  Created by Shahudaa on 30/05/2026.
//

import Swinject


final class AppViewModelFactory: ViewModelFactoryProtocol {

    private let container: Container

    init(container: Container) {
        self.container = container
    }

	func makeHomeViewModel() -> HomeViewModel {
        container.resolve(HomeViewModel.self)!
    }

    func makeDayDetailsViewModel(day: ForecastDay) -> DayDetailsViewModel {
        container.resolve(DayDetailsViewModel.self, argument: day)!
    }

    func makeSavedLocationsViewModel() -> SavedLocationsViewModel {
        container.resolve(SavedLocationsViewModel.self)!
    }

	func makeExploreLocationsViewModel() -> ExploreLocationsViewModel {
		container.resolve(ExploreLocationsViewModel.self)!
	}
}
