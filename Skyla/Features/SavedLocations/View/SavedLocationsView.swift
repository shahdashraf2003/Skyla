//
//  SavedLocationsView.swift
//  Skyla
//
//  Created by Shahudaa on 30/05/2026.
//

import SwiftUI
struct SavedLocationsView: View {
	@EnvironmentObject var weatherContext: WeatherContext
	@StateObject var viewModel: SavedLocationsViewModel
	@State private var locationToDelete: SavedLocation?
	let onSelectLocation: (SavedLocation) -> Void 
	var foregroundColor: Color {
		weatherContext.theme == .day ? .black : .white
	}
	var backGroundColor: Color {
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

				List{
					ForEach(viewModel.locations) { location in
						SavedLocationRow(
							location: location,
							foregroundColor: foregroundColor
						)
						.contentShape(Rectangle())
						.onTapGesture {
							onSelectLocation(location)
						}
						.listRowBackground(Color.clear)
						.listRowSeparator(.hidden)
						.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
						.swipeActions(edge: .trailing, allowsFullSwipe: false) {
							if !location.isCurrent {
								Button(role: .destructive) {
									locationToDelete = location
								} label: {
									Label("Delete", systemImage: "trash")
								}
							}
						}

						if location.isCurrent && viewModel.locations.count > 1 {
							Rectangle()
								.fill(foregroundColor.opacity(0.5))
								.frame(height: 0.5)
								.listRowBackground(Color.clear)
								.listRowSeparator(.hidden)
						}
					}
				}
				.environment(\.defaultMinListRowHeight, 0)
				.scrollContentBackground(.hidden)
				.padding(.horizontal, weatherContext.theme == .night ? 40 : 0)

			}
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
			Button {
				viewModel.showAddLocation = true
			} label: {
				Image(systemName: "plus")
					.font(.title2)
					.foregroundColor(backGroundColor)
					.frame(width: 56, height: 56)
					.background(foregroundColor.opacity(0.9))
					.clipShape(Circle())
					.shadow(radius: 8)
			}
			.padding(.horizontal, weatherContext.theme == .night ? 52 : 8)
		}
	}
}
