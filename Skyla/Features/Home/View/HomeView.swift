//
//  HomeView.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//
import SwiftUI

struct HomeView: View {

	@StateObject var viewModel: HomeViewModel
	
	var body: some View {
		ZStack {
			Image(viewModel.backgroundImageName)
				.resizable()
				.scaledToFill()
				.ignoresSafeArea()

			if viewModel.isLoading {
				ProgressView().tint(viewModel.foregroundColor)
			} else if viewModel.weather != nil {
				content
			} else if let error = viewModel.errorMessage {


				Text(error).foregroundColor(.red).padding()
			}
		}
		.foregroundColor(viewModel.foregroundColor)
		.onAppear {
			viewModel.fetchWeather(lat: 30.07, lon: 31.02)
		}
	}


	private var content: some View {
		ScrollView {
			VStack(spacing: 24) {
				TopSectionView(
					locationName: viewModel.locationName,
					iconURL: viewModel.currentConditionIconURL,
					temperature: viewModel.currentTemperature,
					conditionText: viewModel.conditionText,
					highLowText: viewModel.todayHighLow
				)
				forecastSection
				infoGrid
			}
			.padding(.bottom, 32)
		}
	}




		// MARK: MIDDLE — 3-Day Forecast
	private var forecastSection: some View {
		VStack(alignment: .leading, spacing: 12) {
			Text("3-DAY FORECAST")
				.font(.caption).fontWeight(.bold).opacity(0.8)

			Divider().background(viewModel.foregroundColor.opacity(0.3))

			ForEach(Array(viewModel.threeDayForecast.enumerated()), id: \.element.id) { index, row in
				HStack {
					Text(row.label)
						.frame(width: 110, alignment: .leading)

					AsyncImage(url: row.iconURL) { image in
						image.resizable().scaledToFit()
					} placeholder: { Color.clear }
						.frame(width: 36, height: 36)

					Spacer()

					Text(row.range)
				}
				.font(.body)

				if index < viewModel.threeDayForecast.count - 1 {
					Divider().background(viewModel.foregroundColor.opacity(0.2))
				}
			}
		}
		.padding()
		.background(
			RoundedRectangle(cornerRadius: 16)
				.fill(viewModel.foregroundColor.opacity(0.08))
		)
		.padding(.horizontal)
	}

		// MARK: BOTTOM
	private var infoGrid: some View {
		LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
			ForEach(viewModel.infoItems) { item in
				InfoCard(title: item.title,
						 value: item.value,
						 foreground: viewModel.foregroundColor)
			}
		}
		.padding(.horizontal)
	}
}

	// MARK: - Reusable Card
private struct InfoCard: View {
	let title: String
	let value: String
	let foreground: Color

	var body: some View {
		VStack(alignment: .leading, spacing: 6) {
			Text(title).font(.caption).opacity(0.7)
			Text(value).font(.title3).fontWeight(.semibold)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding()
		.background(
			RoundedRectangle(cornerRadius: 16)
				.fill(foreground.opacity(0.08))
		)
	}
}
