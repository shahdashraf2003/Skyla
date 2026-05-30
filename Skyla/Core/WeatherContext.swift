//
//  WeatherContext.swift
//  Skyla
//
//  Created by Shahudaa on 30/05/2026.
//
import Combine

final class WeatherContext: ObservableObject {
    var localTime: String?

    var hour: Int {
        WeatherTimeProvider(localTime: localTime).hour
    }

    var theme: WeatherTheme {
        ThemeHelper.theme(hour: hour)
    }
}
