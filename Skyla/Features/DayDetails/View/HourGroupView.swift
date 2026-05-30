//
//  HourGroupView.swift
//  Skyla
//
//  Created by Shahudaa on 29/05/2026.
//


import SwiftUI

struct HourGroupView: View {

    let group: [HourWeather]

    var body: some View {

        VStack(alignment: .leading, spacing: 8) {

            Text(groupTitle)
                .font(.caption)
                .opacity(0.6)

            ForEach(group, id: \.time) { hour in
                HourCell(hour: hour)
            }
        }
        .padding()
        .frame(width: 140)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.1))
        )
    }

    private var groupTitle: String {
        guard let first = group.first else { return "" }
		return DateHelper.formatTime(first.time)
		
    }
}
