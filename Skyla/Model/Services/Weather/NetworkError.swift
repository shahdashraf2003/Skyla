//
//  NetworkError.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//


import Foundation

enum NetworkError: LocalizedError {

	case invalidURL
	case requestFailed
	case decodingFailed
	case noInternet
	case locationDenied

	var errorDescription: String? {

		switch self {

			case .invalidURL:
				return "Invalid URL"

			case .requestFailed:
				return "Something went wrong"

			case .decodingFailed:
				return "Failed to load data"

			case .noInternet:
				return "No Internet Connection"

			case .locationDenied:
				return "Location Permission Denied"
		}
	}
}
