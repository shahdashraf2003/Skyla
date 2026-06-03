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

    var foregroundColor: Color {
        weatherContext.theme == .day ? .black : .white
    }
    var horizontalPadding: CGFloat {
        foregroundColor == .black ? 16 : 54
    }

    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

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

                if !isSearching {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(viewModel.suggested, id: \.self) { item in
                                SuggestedCityCard(
                                    title: item,
                                    foregroundColor: foregroundColor
                                ) {
                                    viewModel.selectSuggestedByName(item)
                                }
                            }
                        }
                        .padding(.horizontal, horizontalPadding)
                        
                    }
                    .scrollContentBackground(.hidden)
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            if viewModel.isSearching {
                                ProgressView()
                                    .foregroundColor(foregroundColor)
                                    .padding(.top, 60)

                            } else if viewModel.showNoInternet {
                               
                                NoInternetView(
                                    retry: { await viewModel.retrySearch() },
                                    foregroundColor: foregroundColor
                                )
                                .padding(.top, 60)

                            } else if viewModel.showNoResults {
                                NoResultsView(
                                    query: viewModel.query,
                                    foregroundColor: foregroundColor
                                )

                            } else {
                                ForEach(viewModel.results) { item in
                                    CityResultCard(
                                        item: item,
                                        foregroundColor: foregroundColor
                                    ) {
                                        viewModel.selectCity(item)
                                    }
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                                }
                            }
                        }
                        .padding(horizontalPadding)
                    }
                    .scrollContentBackground(.hidden)
                }

                if viewModel.isLoadingCity {
                    ProgressView("Loading...")
                        .foregroundColor(foregroundColor)
                }
            }
        }
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Explore Locations")
                    .foregroundColor(foregroundColor)
                    .font(.headline)
            }
        }
        .onChange(of: viewModel.shouldDismiss) { _, value in
            if value { dismiss() }
        }
        .alert("Location", isPresented: $viewModel.showAddAlert) {
            Button("Add to Saved") { viewModel.confirmAddToSaved() }
            Button("View Weather") { viewModel.confirmViewWeather() }
            Button("Cancel", role: .cancel) {}
        } message: {
            if let city = viewModel.selectedCity {
                Text("What do you want to do with \(city.name)?")
            }
        }
    }
}


