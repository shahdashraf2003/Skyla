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
	var foregroundColor: Color {
		viewModel.theme == .day ? .black : .white
	}

	@Environment(\.scenePhase) private var scenePhase
	var body: some View {
		NavigationStack {
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
			.foregroundColor(foregroundColor)
			.onAppear {
				viewModel.onAppear()
			}
			.onChange(of: scenePhase) { phase in
				if phase == .active {
					viewModel.checkLocationPermission()
				}
			}.navigationDestination(item: $viewModel.selectedDay) { day in
				DayDetailsView(
					viewModel: DayDetailsViewModel(day: day)
				)
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
					foregroundColor: foregroundColor,
					threeDayForecast: viewModel.threeDayForecast,
					onSelectDay: { day in
						viewModel.selectedDay = day.day
					}
				)

				infoGrid(
					infoItems: viewModel.infoItems,
					foregroundColor: foregroundColor
				)
			}
			.animation(.easeInOut, value: viewModel.isConnected)
			.padding(.bottom, 32)
		}
		.refreshable {
			viewModel.refresh()
		}
	}
}
