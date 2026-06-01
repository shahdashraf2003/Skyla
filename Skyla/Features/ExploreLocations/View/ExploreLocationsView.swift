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

	var body: some View {
		VStack(spacing: 16) {

			TextField("Search city...", text: $viewModel.query)
				.textFieldStyle(.roundedBorder)
				.padding()

			ScrollView(.vertical, showsIndicators: false) {
				let columns = [GridItem(.adaptive(minimum: 90), spacing: 4)]
				LazyVGrid(columns: columns, spacing: 12) {
					ForEach(viewModel.suggested, id: \.self) { item in
						LocationChip(title: item) {
							viewModel.selectSuggestedByName(item)
						}
						.frame(minWidth: 80, maxWidth: .infinity)
					}
				}
			}

			if viewModel.isLoadingCity {
				ProgressView("Loading...")
			}

			List(viewModel.results) { item in
				VStack(alignment: .leading) {
					Text(item.name)
					Text(item.country)
						.font(.caption)
						.foregroundColor(.gray)
				}
				.onTapGesture {
					viewModel.selectCity(item)
				}
			}
		}
		.navigationTitle("Explore Locations")
		.onChange(of: viewModel.shouldDismiss) { _, value in
			if value { dismiss() }
		}.alert(
			"Location",
			isPresented: $viewModel.showAddAlert
		) {
			Button("Add to Saved") {
				viewModel.confirmAddToSaved()
				dismiss()
			}
			Button("View Weather") {
				viewModel.confirmViewWeather()
				dismiss()
			}
			Button("Cancel", role: .cancel) {}
		} message: {
			if let city = viewModel.selectedCity {
				Text("What do you want to do with \(city.name)?")
			}
		}
	}
}
