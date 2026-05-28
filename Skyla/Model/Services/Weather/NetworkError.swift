//
//  NetworkError.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//


import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
    case unknown
}
