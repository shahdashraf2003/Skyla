//
//  HomeView.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//
import SwiftUI
internal import _LocationEssentials

struct HomeView: View {

	@StateObject var viewModel: HomeViewModel
	@StateObject private var locationManager = LocationManager()

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
			viewModel.onAppear()
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
				ForecastSection(
					foregroundColor: viewModel.foregroundColor,
					threeDayForecast: viewModel.threeDayForecast
				
				)
				
				infoGrid
			}
			.padding(.bottom, 32)
		}
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
