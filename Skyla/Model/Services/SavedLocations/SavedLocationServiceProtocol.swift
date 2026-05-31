//
//  SavedLocationServiceProtocol.swift
//  Skyla
//
//  Created by Shahudaa on 30/05/2026.
//


protocol SavedLocationServiceProtocol {
	func fetch() -> [SavedLocation]
	func add(_ location: SavedLocation)
	func delete(_ location: SavedLocation)
	func exists(lat: Double, lon: Double) -> Bool
}
