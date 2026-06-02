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

    var body: some View {
        ZStack {
            Image(weatherContext.theme.backgroundImage)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 12) {
                SearchBar(query: $viewModel.query,foregroundColor: foregroundColor,horizontalPadding: horizontalPadding)
            
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(viewModel.suggested, id: \.self) { item in
                            LocationChip(title: item ,foregroundColor: foregroundColor) {
                                viewModel.selectSuggestedByName(item)
                            
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                List {

                    ForEach(viewModel.results) { item in
                        VStack(alignment: .leading, spacing: 4) {

                            Text(item.name)
                                .font(.headline)
                                .foregroundColor(foregroundColor)

                            Text(item.country)
                                .font(.caption)
                                .foregroundColor(foregroundColor.opacity(0.7))
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.selectCity(item)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(
                            EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                        )
                    }
                }
                .scrollContentBackground(.hidden)
                if viewModel.isLoadingCity {
                    ProgressView("Loading...")
                        .foregroundColor(foregroundColor)
                }

             
               
            }
        }
        .navigationTitle("Explore Locations")
        .foregroundColor(foregroundColor)
        .navigationBarTitleDisplayMode(.inline)
       

        .onChange(of: viewModel.shouldDismiss) { _, value in
            if value { dismiss() }
        }

        .alert("Location", isPresented: $viewModel.showAddAlert) {

            Button("Add to Saved") {
                viewModel.confirmAddToSaved()
            }

            Button("View Weather") {
                viewModel.confirmViewWeather()
            }

            Button("Cancel", role: .cancel) {}
        } message: {
            if let city = viewModel.selectedCity {
                Text("What do you want to do with \(city.name)?")
            }
        }
    }
}
