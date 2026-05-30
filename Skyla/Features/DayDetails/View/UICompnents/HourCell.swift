//
//  HourCell.swift
//  Skyla
//
//  Created by Shahudaa on 29/05/2026.
//


import SwiftUI

struct HourCell: View {

	let hour: HourUIModel
    var body: some View {

        HStack {
			if hour.isNow {
				Text(hour.displayTitle)
					.font(.title2)
					.fontWeight(.bold)
					.foregroundColor(.orange)
			} else {
				Text(hour.displayTitle)
					.font(.title3)
			}
			RemoteImage(url: URLHelper.weatherIconURL(hour.hour.condition.icon))
                    .frame(width: 45, height: 45)
			Spacer()
			Text("\(Int(hour.hour.tempC))°")
				.font(.title)
				.fontWeight(.bold)
				.foregroundColor(ThemeHelper.opColorTheme())


		}
    }
}

