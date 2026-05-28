//
//  WeatherTheme.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//



enum WeatherTheme {

    case day
    case night
    var backgroundImage: String {
        switch self {
        case .day:
            return "morning"
        case .night:
            return "night"
        }
    }
}



