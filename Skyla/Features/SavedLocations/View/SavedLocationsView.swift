//
//  SavedLocationsView.swift
//  Skyla
//
//  Created by Shahudaa on 30/05/2026.
//

import SwiftUI
struct SavedLocationsView: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var weatherContext: WeatherContext
	@Binding var closeSavedLocations: Bool
    @StateObject var viewModel: SavedLocationsViewModel
    @State private var locationToDelete: SavedLocation?
    @State private var didAppear = false
    let factory = AppContainer.shared.makeFactory()

    let onSelectLocation: (SavedLocation) -> Void
    let onViewWeather: (City, Location) -> Void

    var foregroundColor: Color {
        weatherContext.theme == .day ? .black : .white
    }

    var backgroundColor: Color {
        weatherContext.theme == .day ? .white : .black
    }

    var body: some View {
        ZStack {

            Image(weatherContext.theme.backgroundImage)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            if viewModel.isEmpty {
                EmptySavedLocationsView(foregroundColor: foregroundColor)
            } else {
                SavedLocationsListView(
                    locations: viewModel.locations,
                    foregroundColor: foregroundColor,
                    onSelect: { location in
                        onSelectLocation(location)
                    },
                    onDeleteRequest: { location in
                        locationToDelete = location
                    }
                )
                .padding(.horizontal, weatherContext.theme == .night ? 40 : 0)
                
            }
        }
        .offset(x: didAppear ? 0 : 30)
        .opacity(didAppear ? 1 : 0)
        .animation(.easeOut(duration: 0.35), value: didAppear)
        .onAppear {
            didAppear = true
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
                Text("Saved Locations")
                    .font(.headline)
                    .foregroundColor(foregroundColor)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $viewModel.navigateToExplore) {
            exploreView
        }
        .confirmationDialog(
            "Remove \(locationToDelete?.name ?? "")?",
            isPresented: Binding(
                get: { locationToDelete != nil },
                set: { if !$0 { locationToDelete = nil } }
            ),
            titleVisibility: .visible
        ) {
            Button("Remove", role: .destructive) {
                if let location = locationToDelete {
                    viewModel.delete(location)
                    locationToDelete = nil
                }
            }

            Button("Cancel", role: .cancel) {
                locationToDelete = nil
            }
        } message: {
            Text("This location will be removed from your saved list.")
        }
        .overlay(alignment: .bottomTrailing) {
            AddButton(addTapped: viewModel.addTapped, backgroundColor: backgroundColor, foregroundColor: foregroundColor, weatherContext: weatherContext)
                .scaleEffect(didAppear ? 1 : 0.8)
                .opacity(didAppear ? 1 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: didAppear)
        }
    }

    

    
  

    private var exploreView: some View {
        let vm = factory.makeExploreLocationsViewModel()

        vm.onAddToSaved = { [viewModel] city in
            let saved = viewModel.buildSavedLocation(from: city)
            onSelectLocation(saved)
			dismiss()

        }

		vm.onViewWeather = { city, location in
			onViewWeather(city, location)

			closeSavedLocations = false
		}
        return ExploreLocationsView(viewModel: vm)
    }
}
