//
//  HourGroupView.swift
//  Skyla
//
//  Created by Shahudaa on 29/05/2026.
//

import SwiftUI


struct HourGroupView: View {

	let group: [HourWeather]

	private var models: [HourUIModel] {
		group.map { hour in
			let date = DateHelper.parseDateTime(hour.time)

			let isNow = Calendar.current.isDate(date, equalTo: Date(), toGranularity: .hour)

			return HourUIModel(
				hour: hour,
				isNow: isNow, displayTitle: isNow ? "Now" : DateHelper
					.formatTime(hour.time)
			)
		}
	}

	var body: some View {

		VStack(alignment: .leading, spacing: 8) {

			Text(groupTitle)
				.font(.caption)
				.opacity(0.6)
			Divider()
				.background(.foreground.opacity(0.7))
			ForEach(models) { model in
				HourCell(
					hour: model

				)
			}
		}
		.padding()
		.background(
			RoundedRectangle(cornerRadius: 16)
				.fill(.foreground.opacity(0.1))
		)
	}

	private var groupTitle: String {
		guard let first = group.first else { return "" }
		return DateHelper.formatTime(first.time)
	}
}
