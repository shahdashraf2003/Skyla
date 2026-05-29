//
//  APIClient.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//


import Foundation

protocol APIClientProtocol {
	func request<T: Codable>(_ endpoint: Endpoint) async throws -> (T,Bool)
}

final class APIClient: APIClientProtocol {

	private let session: URLSession
	private let cache: URLCache

	init() {
		
		let cache = URLCache(
			memoryCapacity: 50 * 1024 * 1024,
			diskCapacity: 100 * 1024 * 1024
		)

		let config = URLSessionConfiguration.default
		config.urlCache = cache
		config.requestCachePolicy = .reloadIgnoringLocalCacheData

		self.cache = cache
		self.session = URLSession(configuration: config)
	}

	func request<T: Codable>(_ endpoint: Endpoint) async throws -> (T ,Bool){
		guard let url = endpoint.url else { throw NetworkError.invalidURL }

		let urlRequest = URLRequest(url: url)

		do {
			let (data, response) = try await session.data(for: urlRequest)

			guard let httpResponse = response as? HTTPURLResponse,
				  200..<300 ~= httpResponse.statusCode else {
				throw NetworkError.requestFailed
			}

			let cachedResponse = CachedURLResponse(response: response, data: data)
			cache.storeCachedResponse(cachedResponse, for: urlRequest)
			print("api")
			return try (JSONDecoder().decode(T.self, from: data),false)

		} catch {
			if let urlError = error as? URLError {
				switch urlError.code {
					case .notConnectedToInternet,
							.cannotFindHost,
							.dnsLookupFailed,
							.networkConnectionLost:
						if let cached = cache.cachedResponse(for: urlRequest) {
							print("cashed")
							return try (JSONDecoder().decode(T.self, from: cached.data),true)
						}


						throw NetworkError.noInternet
					default:
						throw error
				}
			}
			throw error
		}
	}
}
