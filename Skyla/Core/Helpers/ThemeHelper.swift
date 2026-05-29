//
//  ThemeHelper.swift
//  Skyla
//
//  Created by Shahd Ashraf  on 28/05/2026.
//

import Foundation
import SwiftUI


struct ThemeHelper {

    static func currentTheme() -> WeatherTheme {
        let hour = Calendar.current.component(.hour, from: Date())
        return (hour >= 5 && hour < 18) ? .day : .night
    }

	static func opColorTheme() -> Color {
		let hour = Calendar.current.component(.hour, from: Date())
		return (hour >= 5 && hour < 18) ? .white : .black
	}
}
