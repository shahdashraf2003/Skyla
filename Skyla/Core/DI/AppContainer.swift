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
    }
}
