//
//  ExploreLocationsView.swift
//  Skyla
//
//  Created by Shahudaa on 31/05/2026.
//


import SwiftUI


struct ExploreLocationsView: View {

    @StateObject var viewModel: ExploreLocationsViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var weatherContext: WeatherContext

    @State private var didAppear = false

    var foregroundColor: Color {
        weatherContext.theme == .day ? .black : .white
    }

    var horizontalPadding: CGFloat {
        foregroundColor == .black ? 16 : 54
    }

    var isSearching: Bool {
        !viewModel.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        ZStack {
            Image(weatherContext.theme.backgroundImage)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 12) {

                SearchBar(
                    query: $viewModel.query,
                    foregroundColor: foregroundColor,
                    horizontalPadding: horizontalPadding
                )
                .transition(.move(edge: .top).combined(with: .opacity))

                if !isSearching {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Popular cities")
                                .font(.system(size: 14))
                                .foregroundColor(foregroundColor)
                                .padding(.horizontal, horizontalPadding)

                            FlowLayout(spacing: 10) {
                                ForEach(viewModel.suggested, id: \.self) { item in
                                    SuggestedCityCard(
                                        title: item,
                                        foregroundColor: foregroundColor
                                    ) {
                                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                            viewModel.selectSuggestedByName(item)
                                        }
                                    }
                                    .transition(.scale.combined(with: .opacity))
                                }
                            }
                            .padding(.horizontal, horizontalPadding)
                            .animation(.easeInOut(duration: 0.25), value: viewModel.suggested)
                        }
                        .padding(.top, 4)
                    }
                    .scrollContentBackground(.hidden)

                } else {

                    ScrollView {
                        VStack(spacing: 12) {

                            if viewModel.isSearching {
                                LoadingView(foregroundColor: foregroundColor)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .transition(.opacity)
                            }

                            else if viewModel.showNoInternet {
                                NoInternetView(
                                    retry: { await viewModel.retrySearch() },
                                    foregroundColor: foregroundColor
                                )
                                .padding(.top, 60)
                                .transition(.opacity)
                            }

                            else if viewModel.showNoResults {
                                NoResultsView(
                                    query: viewModel.query,
                                    foregroundColor: foregroundColor
                                )
                                .transition(.opacity)
                            }

                            else {
                                ForEach(viewModel.results) { item in
                                    CityResultCard(
                                        item: item,
                                        foregroundColor: foregroundColor
                                    ) {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                                            viewModel.selectCity(item)
                                        }
                                    }
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                                }
                            }
                        }
                        .padding(horizontalPadding)
                        .animation(.easeInOut(duration: 0.3), value: viewModel.results)
                        .animation(.easeInOut(duration: 0.3), value: viewModel.isSearching)
                        .animation(.easeInOut(duration: 0.3), value: viewModel.showNoResults)
                        .animation(.easeInOut(duration: 0.3), value: viewModel.showNoInternet)
                    }
                    .scrollContentBackground(.hidden)
                }

                if viewModel.isLoadingCity {
                    LoadingView(foregroundColor: foregroundColor)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.2), value: viewModel.isLoadingCity)
                }
            }
            .opacity(didAppear ? 1 : 0)
            .offset(y: didAppear ? 0 : 20)
            .animation(.easeOut(duration: 0.35), value: didAppear)
        }

        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(foregroundColor)
                }
            }

            ToolbarItem(placement: .principal) {
                Text("Explore Locations")
                    .font(.headline)
                    .foregroundColor(foregroundColor)
            }
        }

        .navigationBarBackButtonHidden(true)
		.onAppear {
			didAppear = true
		}
        .alert("Location", isPresented: $viewModel.showAddAlert) {
            Button("Add to Saved") { viewModel.confirmAddToSaved() }
            Button("View Weather") { viewModel.confirmViewWeather() }
            Button("Cancel", role: .cancel) {}
        } message: {
            if let city = viewModel.selectedCity {
                Text("What do you want to do with \(city.name)?")
            }
		}.sheet(isPresented: $viewModel.showNoInternet) {
			NoInternetView(
				retry: {
					await viewModel.retrySearch()
					if !viewModel.showNoInternet {
					
						viewModel.showNoInternet = false
					}
				},
				foregroundColor: .primary
			)
			.presentationDetents([.medium])
		}
    }
}
