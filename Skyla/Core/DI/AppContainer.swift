//
//  AppContainer.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//


import Swinject

final class AppContainer {

    static let shared = AppContainer()

    let container = Container()

    private init() {
        registerDependencies()
    }

    private func registerDependencies() {


        container.register(APIClientProtocol.self) { _ in
            APIClient()
        }


        container.register(WeatherServiceProtocol.self) { resolver in
            let client = resolver.resolve(APIClientProtocol.self)!
            return WeatherService(apiClient: client)
        }

		container.register((any LocationServiceProtocol).self){ _  in
			LocationManager()
		}

		container.register(WeatherRepositoryProtocol.self) { resolver in
			let weatherService = resolver.resolve(WeatherServiceProtocol.self)!
			let locationService = resolver.resolve(
				(any LocationServiceProtocol).self
			)!
			return WeatherRepository(
				waetherService: weatherService,
				locationService: locationService
			)
		}

		container.register(HomeViewModel.self) { resolver in
			let repo = resolver.resolve(WeatherRepositoryProtocol.self)!
			return HomeViewModel(weatherRepository:repo)
		}
    }
}
