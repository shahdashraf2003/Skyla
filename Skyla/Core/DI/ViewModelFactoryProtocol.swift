//
//  ViewModelFactory.swift
//  Skyla
//
//  Created by Shahudaa on 30/05/2026.
//


import Foundation

protocol ViewModelFactoryProtocol {
    
	func makeHomeViewModel() -> HomeViewModel

	func makeDayDetailsViewModel(day: ForecastDay) -> DayDetailsViewModel

	func makeSavedLocationsViewModel() -> SavedLocationsViewModel

	func makeExploreLocationsViewModel() -> ExploreLocationsViewModel


}
