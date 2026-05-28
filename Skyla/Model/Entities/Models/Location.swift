//
//  Location.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//


struct Location: Codable {

    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let tzId: String
    let localtime: String

    enum CodingKeys: String, CodingKey {

        case name
        case region
        case country
        case lat
        case lon
        case tzId = "tz_id"
        case localtime
    }
}
