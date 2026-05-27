//
//  APIClientProtocol.swift
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

	init() {

		let config = URLSessionConfiguration.default

		config.requestCachePolicy = .returnCacheDataElseLoad

		config.urlCache = URLCache(
			memoryCapacity: 50 * 1024 * 1024,
			diskCapacity: 100 * 1024 * 1024
		)

		self.session = URLSession(configuration: config)
	}

	func request<T: Codable>(_ endpoint: Endpoint) async throws -> T {
		guard let url = endpoint.url else { throw NetworkError.invalidURL }
		do {
			let (data, response) = try await session.data(from: url)

			guard let httpResponse = response as? HTTPURLResponse,
				  200..<300 ~= httpResponse.statusCode else {
				throw NetworkError.requestFailed
			}

			let decoded = try JSONDecoder().decode(T.self, from: data)
			return decoded
		}
		catch {
			if let urlError = error as?
				URLError, urlError.code == .notConnectedToInternet
			{
				throw NetworkError.noInternet
			}
			throw error
		}
	}
}
