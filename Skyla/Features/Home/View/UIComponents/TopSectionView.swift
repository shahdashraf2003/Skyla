//
//  File.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//

import SwiftUI
struct TopSectionView: View {

	let locationName: String
	let iconURL: URL?
	let temperature: String
	let conditionText: String
	let highLowText: String

	var body: some View {

		VStack(spacing: 8) {
			Text(locationName)
				.font(.title)
				.fontWeight(.semibold)

			RemoteImage(url: iconURL)
			.frame(width: 130, height: 130)

			Text(temperature)
				.font(.system(size: 64, weight: .thin))

			Text(conditionText)
				.font(.headline)

			Text(highLowText)
				.font(.subheadline)
		}
		.padding(.top, 40)
	}
}
