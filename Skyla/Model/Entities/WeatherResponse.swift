//
//  WeatherResponse.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026 
//


import Foundation

struct WeatherResponse: Codable {

    let location: Location
    let current: CurrentWeather
    let forecast: Forecast
}


