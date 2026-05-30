//
//  AppContainer.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//


import Swinject
import Foundation

final class AppContainer {

    static let shared = AppContainer()

    let container = Container()

    private init() {
        registerDependencies()
    }

    private func registerDependencies() {

		container.register(APIClientProtocol.self) { _ in

			let cache = URLCache(
				memoryCapacity: 50 * 1024 * 1024,
				diskCapacity: 100 * 1024 * 1024
			)

			let config = URLSessionConfiguration.default
			config.urlCache = cache
			config.requestCachePolicy = .reloadIgnoringLocalCacheData

			let session = URLSession(configuration: config)

			return APIClient(session: session, cache: cache)
		}

        container.register(WeatherServiceProtocol.self) { resolver in
            let client = resolver.resolve(APIClientProtocol.self)!
            return WeatherService(apiClient: client)
        }

		container.register(WeatherRepositoryProtocol.self) { resolver in
			let service = resolver.resolve(WeatherServiceProtocol.self)!
			return WeatherRepository(service:service)
		}


		container.register(LocationServiceProtocol.self) { _ in
			LocationManager()
		}.inObjectScope(.container)

		container.register(HomeViewModel.self) { resolver in
			let repo = resolver.resolve(WeatherRepositoryProtocol.self)!
			let locationService = resolver.resolve(LocationServiceProtocol.self)!
			return HomeViewModel(
				weatherRepository: repo,
				locationService:  locationService
			)
		}

		container.register(DayDetailsViewModel.self) { (_, day: ForecastDay) in
			return DayDetailsViewModel(day: day)
		}


    }
}
