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

	var body: some View {
		ZStack {
			Image(viewModel.backgroundImageName)
				.resizable()
				.scaledToFill()
				.ignoresSafeArea()

			if viewModel.isLoading && viewModel.weather == nil {
				ProgressView()
					.tint(viewModel.foregroundColor)
			} else if viewModel.weather != nil {
				content
			} else if let error = viewModel.errorMessage {
				ErrorView(
					message: error,
					retryAction: {  viewModel.onAppear() }
				)
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

				if viewModel.isShowingCachedData {
					CachedBannerView()
						.transition(.move(edge: .top).combined(with: .opacity))
				}

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

				infoGrid(
					infoItems: viewModel.infoItems,
					foregroundColor: viewModel.foregroundColor
				)
			}.animation(.easeInOut, value: viewModel.isConnected).padding(.bottom, 32)
		}.refreshable {
			await viewModel.refresh()
		}
	}
}
