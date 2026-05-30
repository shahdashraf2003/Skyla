//
//  SavedLocationServiceProtocol.swift
//  Skyla
//
//  Created by Shahudaa on 30/05/2026.
//


protocol SavedLocationServiceProtocol {
    func fetch() -> [SavedLocation]
    func add(_ item: SavedLocation)
    func delete(_ item: SavedLocation)
}