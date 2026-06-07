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
    @EnvironmentObject var context: WeatherContext
    @Environment(\.scenePhase) private var scenePhase
    @State private var didAppear = false
    var foregroundColor: Color {
        context.theme == .day ? .black : .white
    }

    var backgroundColor: Color {
        context.theme == .day ? .white : .black
    }
  


    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                backgroundImage
                mainContent
            }
            .opacity(didAppear ? 1 : 0)
            .offset(y: didAppear ? 0 : 20)
            .animation(.easeOut(duration: 0.35), value: didAppear)
            .onAppear {
                onAppear()
                didAppear = true
            }
            .onChange(of: scenePhase, perform: onScenePhaseChange)
            .navigationDestination(item: $viewModel.selectedDay) { day in
                DayDetailsView(viewModel: factory.makeDayDetailsViewModel(day: day))
            }
            .navigationDestination(isPresented: $viewModel.showSavedLocations) {
                savedLocationsDestination
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    savedLocationsButton
                }
            }
        }
    }

    @ViewBuilder
    private var mainContent: some View {
        if viewModel.isTemporaryLocation {
            locationPage.overlay(alignment: .top) {
                notSavedBadge
            }
        } else {
            pagedLocations
        }
    }

    private var pagedLocations: some View {
        ZStack(alignment: .top) {
            TabView(selection: $viewModel.currentLocationIndex) {
                if viewModel.allLocations.isEmpty {
                    locationPage.tag(0)
                } else {
                    ForEach(Array(viewModel.allLocations.enumerated()), id: \.offset) { index, _ in
                        locationPage.tag(index)
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.spring(response: 0.4, dampingFraction: 0.85), value: viewModel.state)
            .onChange(of: viewModel.currentLocationIndex) { _, index in
                viewModel.navigateToLocation(at: index)
            }

            if viewModel.allLocations.count > 1 {
                PageIndicator(
                    foregroundColor: foregroundColor,
                    allLocations: viewModel.allLocations,
                    currentIndex: viewModel.currentLocationIndex
                )
            }
        }
    }

    private var locationPage: some View {
        ZStack {
            switch viewModel.state {

            case .loading:
                LoadingView(foregroundColor: foregroundColor)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.opacity)

            case .loaded:
                content
                    .transition(.opacity.combined(with: .move(edge: .bottom)))

            case .empty:
                EmptyStateView()
                    .transition(.opacity)

            case .locationDenied:
                PermissionDeniedView(openSettingsAction: openSettings)
                    .transition(.opacity)

            case .noInternet:

                NoInternetView(
                    retry: { await viewModel.refresh() },
                    foregroundColor: foregroundColor
                )
				.frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.opacity)

            case .error(let message):
                ErrorView(
                    message: message,
                    retryAction: viewModel.onAppear,
                    backgroundColor: backgroundColor
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: viewModel.state)
        .foregroundColor(foregroundColor)
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
                    foregroundColor: foregroundColor,
                    threeDayForecast: viewModel.threeDayForecast,
                    onSelectDay: { day in viewModel.selectedDay = day.day }
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
    
    private var backgroundImage: some View {
        Image(context.theme.backgroundImage)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }

    private var notSavedBadge: some View {
        HStack(spacing: 6) {
            Image(systemName: "bookmark.slash").font(.caption)
            Text("Not saved").font(.caption)
        }
        .foregroundColor(foregroundColor.opacity(0.7))
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(Capsule().fill(foregroundColor.opacity(0.15)))
        .padding(.top, 8)
    }

    private var savedLocationsButton: some View {
        Button {
            viewModel.showSavedLocations = true
        } label: {
            Image(.music)
                .resizable()
                .frame(width: 32, height: 32)
        }
    }

    private var savedLocationsDestination: some View {
		SavedLocationsView(
			closeSavedLocations: $viewModel.showSavedLocations, viewModel: factory
				.makeSavedLocationsViewModel(),
			onSelectLocation: viewModel.selectLocation,
			onViewWeather: { city, _ in
				viewModel.viewWeather(
					lat: city.lat,
					lon: city.lon,
					name: city.name
				)
			}
		)
    }


    private func onAppear() {
        viewModel.loadLocations()
        viewModel.onAppear()
    }

	private func onScenePhaseChange(_ phase: ScenePhase) {
		guard phase == .active else { return }

		if !viewModel.isViewingSelectedLocation {
			viewModel.checkLocationPermission()
			viewModel.forceLocationRefresh()
		}
	}
    private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}
