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

	func request<T: Codable>(_ endpoint: Endpoint) async throws -> T {

		guard let url = endpoint.url else {
			throw NetworkError.invalidURL
		}

		let (data, response) = try await URLSession.shared.data(from: url)

		guard let httpResponse = response as? HTTPURLResponse,
			  200..<300 ~= httpResponse.statusCode else {
			throw NetworkError.requestFailed
		}

		do {
			let decoded = try JSONDecoder().decode(T.self, from: data)
			return decoded
		} catch {
			throw NetworkError.decodingFailed
		}
	}
}
