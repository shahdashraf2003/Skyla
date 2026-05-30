//
//  HourCell.swift
//  Skyla
//
//  Created by Shahudaa on 29/05/2026.
//


import SwiftUI

struct HourCell: View {

    let hour: HourWeather

    var body: some View {

        HStack {

			Text(DateHelper.formatTime(hour.time))
                .font(.caption)

            Spacer()


                RemoteImage(url: URLHelper.weatherIconURL(hour.condition.icon))
                    .frame(width: 30, height: 30)


            Text("\(Int(hour.tempC))°")
                .font(.caption)
        }
    }
}
