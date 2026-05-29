//
//  Endpoint.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//


import Foundation

enum Endpoint {
    case forecast(lat: Double, lon: Double, days: Int)

    var url: URL? {
        switch self {
        case .forecast(let lat, let lon, let days):
            let apiKey = "65320a03b2864599848161031262605"

            let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(lat),\(lon)&days=\(days)&aqi=yes&alerts=no"

            return URL(string: urlString)
        }
    }
}
