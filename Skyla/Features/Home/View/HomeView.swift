//
//  HomeView.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//
import SwiftUI

struct HomeView: View {
	let factory = AppContainer.shared.makeFactory()
	@StateObject var viewModel: HomeViewModel

	var foregroundColor: Color {
		viewModel.theme == .day ? .black : .white
	}

	var backgroundColor: Color {
		viewModel.theme == .day ? .white : .black
	}

	@Environment(\.scenePhase) private var scenePhase

	var body: some View {
		NavigationStack {
			ZStack(alignment: .top) {
				Image(viewModel.backgroundImageName)
					.resizable()
					.scaledToFill()
					.ignoresSafeArea()
				TabView(selection: $viewModel.currentLocationIndex) {

					if viewModel.allLocations.isEmpty {
						locationPage
							.tag(0)
					} else {
						ForEach(Array(viewModel.allLocations.enumerated()), id: \.offset) { index, _ in
							locationPage
								.tag(index)
						}
					}
				}
				.tabViewStyle(.page(indexDisplayMode: .never))
				.onChange(of: viewModel.currentLocationIndex) { _ , index in
					viewModel.navigateToLocation(at: index)
				}


				if viewModel.allLocations.count > 1 {
					pageIndicator
						.padding(.bottom, 16)
				}
			}
			.onAppear {
				viewModel.loadLocations()
				viewModel.onAppear()
			}
			.onChange(of: scenePhase) { _ , phase in
				if phase == .active {
					viewModel.checkLocationPermission()
				}
			}
			.navigationDestination(item: $viewModel.selectedDay) { day in
				DayDetailsView(
					viewModel: factory.makeDayDetailsViewModel(day: day)
				)
			}
			.navigationDestination(isPresented: $viewModel.showSavedLocations) {
				SavedLocationsView(
					viewModel: factory.makeSavedLocationsViewModel(),
					onSelectLocation: { location in
						viewModel.selectLocation(location)
					}
				)
			}
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						viewModel.showSavedLocations = true
					} label: {
						Image(.music)
							.resizable()
							.frame(width: 32, height: 32)
					}
				}
			}
		}
	}



	private var locationPage: some View {
		ZStack {


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
						retryAction: { viewModel.onAppear() }
					)
			}
		}
		.foregroundColor(foregroundColor)
	}

	private var pageIndicator: some View {
		HStack(spacing: 6) {
			ForEach(Array(viewModel.allLocations.enumerated()), id: \.offset) { index, location in
				if location.isCurrent {
					Image(systemName: "location.fill")
						.font(.system(size: 8))
						.foregroundColor(
							index == viewModel.currentLocationIndex
							? foregroundColor
							: foregroundColor.opacity(0.4)
						)
				} else {
					Circle()
						.fill(
							index == viewModel.currentLocationIndex
							? foregroundColor
							: foregroundColor.opacity(0.4)
						)
						.frame(width: 8, height: 8)
				}
			}
		}
		.padding(.horizontal, 12)
		.padding(.vertical, 6)
		.background(
			Capsule()
				.fill(foregroundColor.opacity(0.15))
		)
	}


	private var content: some View {
		ScrollView {
			VStack(spacing: 24) {
				if viewModel.isShowingCachedData {
					CachedBannerView(
						foreground: foregroundColor,
						backgound: backgroundColor
					)
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
			.padding(.bottom, 48) 
		}
		.refreshable {
			await viewModel.refresh()
		}
	}

	
}
