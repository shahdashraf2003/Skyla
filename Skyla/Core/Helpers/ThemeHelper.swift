//
//  ThemeHelper.swift
//  Skyla
//
//  Created by Shahd Ashraf  on 28/05/2026.
//

import Foundation
import SwiftUI


	struct ThemeHelper {

		static func theme(hour: Int) -> WeatherTheme {
			(hour >= 5 && hour < 18) ? .day : .night
		}

		static func opColorTheme(hour: Int) -> Color {
			(hour >= 5 && hour < 18) ? .white : .black
		}
	}
