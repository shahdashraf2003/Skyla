//
//  APIClient.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//


import Foundation

protocol APIClientProtocol {
	func request<T: Codable>(_ endpoint: Endpoint) async throws -> T
}

final class APIClient: APIClientProtocol {

	private let session: URLSession

	init(session: URLSession) {
		self.session = session
	}

	func request<T: Codable>(
		_ endpoint: Endpoint
	) async throws -> T {

		guard let url = endpoint.url else {
			throw NetworkError.invalidURL
		}

		let urlRequest = URLRequest(url: url)

		do {
			let (data, response) = try await session.data(for: urlRequest)

			guard let httpResponse = response as? HTTPURLResponse,
				  200..<300 ~= httpResponse.statusCode else {
				throw NetworkError.requestFailed
			}

			let decoded = try JSONDecoder().decode(T.self, from: data)

			return decoded

		} catch {
			if let urlError = error as? URLError {
				switch urlError.code {
					case .notConnectedToInternet,
							.networkConnectionLost,
							.cannotFindHost,
							.dnsLookupFailed:
						throw NetworkError.noInternet
					default:
						throw error
				}
			}

			throw error
		}
	}
}
