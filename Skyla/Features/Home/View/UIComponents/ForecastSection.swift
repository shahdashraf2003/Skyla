//
//  ForecastSection.swift
//  Skyla
//
//  Created by Shahd Ashraf  on 28/05/2026.
//

import SwiftUI


struct ForecastSection : View {

	var foregroundColor : Color
	var threeDayForecast : [ForecastRow]

	var  body  : some View {

		VStack(alignment: .leading,spacing: 12) {

			Text("3-DAY FORECAST")
				.font(.caption)
				.fontWeight(.bold)
				.opacity(0.8)
				.padding()

			Divider().background(foregroundColor.opacity(0.3))

			ForEach(Array(threeDayForecast.enumerated()), id: \.element.id) { index, row in
				HStack {
					Text(row.label)
						.frame(width: 110, alignment: .leading)

					AsyncImage(url: row.iconURL) { image in
						image.resizable().scaledToFit()
					} placeholder: { Color.clear }
						.frame(width: 40, height: 28)

					Spacer()

					Text(row.range)
				}
				.font(.body)
				.padding()

				if index < threeDayForecast.count - 1 {
					Divider().background(foregroundColor.opacity(0.2))
				}
			}
		}

		.background(
			RoundedRectangle(cornerRadius: 16)
				.fill(foregroundColor.opacity(0.08))
		)
		.padding(.horizontal,65)

	}
}
