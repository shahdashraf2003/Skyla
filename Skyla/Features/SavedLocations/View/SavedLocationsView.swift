//
//  SavedLocationsView.swift
//  Skyla
//
//  Created by Shahudaa on 30/05/2026.
//

import SwiftUI
import Combine

struct SavedLocationsView: View {

	@StateObject var viewModel : SavedLocationsViewModel
	var foregroundColor: Color {
		viewModel.theme == .day ? .black : .white
	}

	var body: some View {
		ZStack {
			Image(viewModel.backgroundImageName)
				.resizable()
				.scaledToFill()
				.ignoresSafeArea()

			List {

				ForEach(viewModel.locations) { location in

					SavedLocationRow(
						location: location,
						foregroundColor: foregroundColor
					) {
						viewModel.delete(location)
					}
					.listRowBackground(Color.clear)
				}
			}
			.scrollContentBackground(.hidden)
		}.overlay(alignment: .bottomTrailing) {

			Button {

				viewModel.showAddLocation = true

			} label: {

				Image(systemName: "plus")
					.font(.title2)
					.foregroundColor(.white)
					.frame(width: 56, height: 56)
					.background(.blue)
					.clipShape(Circle())
					.shadow(radius: 8)
			}
			.padding()
		}
	}
}
