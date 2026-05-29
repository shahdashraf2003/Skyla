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
	@Environment(\.scenePhase) private var scenePhase
	var body: some View {
		ZStack {
			Image(viewModel.backgroundImageName)
				.resizable()
				.scaledToFill()
				.ignoresSafeArea()

			switch viewModel.state {
				case .loading:
					ProgressView()

				case .loaded:
					content
				case .empty:
					EmptyStateView()

				case .locationDenied:
					PermissionDeniedView(
						openSettingsAction: {
							guard let url = URL(
								string: UIApplication.openSettingsURLString
							) else { return }

							UIApplication.shared.open(url)
						}
					)

				case .error(let message):
					ErrorView(
						message: message,
						retryAction: {
							viewModel.onAppear()
						}
					)

			}
		}
		.foregroundColor(viewModel.foregroundColor)
		.onAppear {
			viewModel.onAppear()
		}.onChange(of: scenePhase){
			if scenePhase == .active {
				viewModel.checkLocationPermission()
			}
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
