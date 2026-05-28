//
//  SavedLocation.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//
import Foundation

struct SavedLocation: Codable, Identifiable, Hashable {

    let id: UUID
    let city: String
    let lat: Double
    let lon: Double
}
