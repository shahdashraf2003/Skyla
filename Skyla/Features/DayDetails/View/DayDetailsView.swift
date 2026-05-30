//
//  DayDetailsView.swift
//  Skyla
//
//  Created by Shahudaa on 29/05/2026.
//


import SwiftUI

struct DayDetailsView: View {

    @StateObject var viewModel: DayDetailsViewModel
	var foregroundColor: Color {
		viewModel.theme == .day ? .black : .white
	}
    var body: some View {
        ZStack {
			Image(viewModel.backgroundImageName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    header
                    HourlyForecastView(hours: viewModel.groupedHours)
                }
                .padding()
				.foregroundColor(foregroundColor)
            }
		}

    }

   

    private var header: some View {
        VStack(spacing: 10) {

            Text(viewModel.conditionText)
                .font(.title2)
                .bold()

            if let icon = viewModel.iconURL {
                RemoteImage(url: icon)
                    .frame(width: 80, height: 80)
            }

            HStack {
				Text(viewModel.rangeTemp)

            }
            .font(.headline)
        }
    }
}
