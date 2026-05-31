//
//  HourGroupView.swift
//  Skyla
//
//  Created by Shahudaa on 29/05/2026.
//

import SwiftUI


struct HourGroupView: View {

	let group: [HourUIModel]
	let backgroundColor : Color

	var body: some View {

		VStack(alignment: .leading, spacing: 8) {

			Text(groupTitle)
				.font(.caption)
				.opacity(0.6)
			Divider()
				.background(.foreground.opacity(0.7))
			ForEach(group) { model in
				HourCell(
					hour: model,
					backgroundColor: backgroundColor

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

		return DateHelper.formatTime(
			first.hour.time
		)
	}
}
