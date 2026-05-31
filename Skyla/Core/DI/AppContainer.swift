//
//  AppContainer.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//


import Swinject
import Foundation
import SwiftData

final class AppContainer {

    static let shared = AppContainer()

    let container = Container()

    private init() {
        registerDependencies()
    }

    private func registerDependencies() {

		container.register(APIClientProtocol.self) { _ in

			let config = URLSessionConfiguration.default
			config.requestCachePolicy = .reloadIgnoringLocalCacheData
			config.urlCache = nil

			let session = URLSession(configuration: config)

			return APIClient(session: session)
		}

        container.register(WeatherServiceProtocol.self) { resolver in
            let client = resolver.resolve(APIClientProtocol.self)!
            return WeatherService(apiClient: client)
        }


		container.register(WeatherRepositoryProtocol.self) { resolver in

			let service = resolver.resolve(WeatherServiceProtocol.self)!

			return WeatherRepository(
				service: service
			)
		}

		container.register(LocationServiceProtocol.self) { _ in
			LocationManager()
		}.inObjectScope(.container)

		container.register(WeatherContext.self) { _ in
			WeatherContext()
		}.inObjectScope(.container)

		
		container.register(HomeViewModel.self) { resolver in
			let repo = resolver.resolve(WeatherRepositoryProtocol.self)!
			let locationService = resolver.resolve(LocationServiceProtocol.self)!
			let savedLocationRepo = resolver.resolve(SavedLocationRepositoryProtocol.self)!
			let weatherContext = resolver.resolve(WeatherContext.self)!

			return HomeViewModel(
				weatherRepository: repo,
				locationService: locationService,
				savedLocationRepository: savedLocationRepo,
				weatherContext: weatherContext
			)
		}

		container.register(DayDetailsViewModel.self) { (resolver, day: ForecastDay) in

			let weatherContext = resolver.resolve(WeatherContext.self)!

			return DayDetailsViewModel(
				day: day,
				localTime: weatherContext.localTime!
			)
		}


		container.register(ModelContainer.self) { _ in
			try! ModelContainer(for: SavedLocation.self)
		}
		.inObjectScope(.container)


		container.register(SavedLocationServiceProtocol.self) { resolver in
			let container = resolver.resolve(ModelContainer.self)!
			return SavedLocationService(context: container.mainContext)
		}


		container.register(SavedLocationRepositoryProtocol.self) { resolver in
			let service = resolver.resolve(SavedLocationServiceProtocol.self)!
			return SavedLocationRepository(service: service)
		}


		container.register(SavedLocationsViewModel.self) { resolver in
			let repo = resolver.resolve(SavedLocationRepositoryProtocol.self)!
			return SavedLocationsViewModel(repo: repo)
		}

    }
	func makeFactory() -> ViewModelFactoryProtocol {
		AppViewModelFactory(container: container)
	}

}

