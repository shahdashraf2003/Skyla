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
    }
}
