//
//  TemperatureFormatter.swift
//  Skyla
//
//  Created by Shahd Ashraf  on 28/05/2026.
//


struct TemperatureFormatter {

    static func format(_ value: Double, unit: String = "°C") -> String {
        "\(Int(value))\(unit)"
    }

    static func range(min: Double, max: Double) -> String {
        "\(Int(min))° - \(Int(max))°"
    }
}
