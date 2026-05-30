//
//  WeatherContext.swift
//  Skyla
//
//  Created by Shahudaa on 30/05/2026.
//
import Combine

final class WeatherContext: ObservableObject {

	@Published var localTime: String?

	@Published private(set) var theme: WeatherTheme = .day

	func updateTime(_ time: String?) {
		self.localTime = time
		let hour = WeatherTimeProvider(localTime: time).hour
		self.theme = ThemeHelper.theme(hour: hour)
	}
}
