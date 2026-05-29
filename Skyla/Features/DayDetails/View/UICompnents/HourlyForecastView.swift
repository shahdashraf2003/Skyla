//
//  HourlyForecastView.swift
//  Skyla
//
//  Created by Shahudaa on 29/05/2026.
//


import SwiftUI

struct HourlyForecastView: View {

    let hours: [[HourWeather]]

	var body: some View {
		
		VStack(alignment: .leading, spacing: 12) {
			
			Text("HOURLY FORECAST")
				.font(.caption)
				.opacity(0.7)
			VStack(spacing: 12) {
				
				ForEach(Array(hours.enumerated()), id: \.offset) { _, group in
					
					HourGroupView(group: group)
				}
			}
			
			
		}}
}
