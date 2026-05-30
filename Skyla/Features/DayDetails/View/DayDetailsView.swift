//
//  DayDetailsView.swift
//  Skyla
//
//  Created by Shahudaa on 29/05/2026.
//


import SwiftUI

struct DayDetailsView: View {
	@EnvironmentObject var weatherContext: WeatherContext
    @StateObject var viewModel: DayDetailsViewModel
	var foregroundColor: Color {
		weatherContext.theme == .day ? .black : .white
	}

	var backgroundColor: Color {
		weatherContext.theme == .day ? .white : .black
	}
	var horizontalPadding: CGFloat {
		foregroundColor == .black ? 45 : 55
	}
    var body: some View {


		ZStack {
			Image(weatherContext.theme.backgroundImage)
				.resizable()
				.scaledToFill()
				.ignoresSafeArea()
			if viewModel.isEmpty {
				EmptyStateView().foregroundColor(foregroundColor)
			}
			else{
				ScrollView {
					VStack(spacing: 20) {
						header
						HourlyForecastView(
							hours: viewModel.groupedHours,
							backgroundColor: backgroundColor
						)
							.padding(.horizontal , horizontalPadding)
					}
					.foregroundColor(foregroundColor)
				}.padding(.horizontal , horizontalPadding-24)
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
