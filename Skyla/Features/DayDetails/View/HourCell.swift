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

			Text(hour.displayTitle)
				.fontWeight(hour.isNow ? .bold : .regular)
				.foregroundColor(hour.isNow ? .orange : .primary)

            Spacer()

			RemoteImage(url: URLHelper.weatherIconURL(hour.hour.condition.icon))
                    .frame(width: 30, height: 30)


			Text("\(Int(hour.hour.tempC))°")
                .font(.caption)
        }
    }
}
