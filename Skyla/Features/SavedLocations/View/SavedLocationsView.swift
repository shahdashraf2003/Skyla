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

	var backGroundColor: Color {
		ThemeHelper.opColorTheme()
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
					}.listRowBackground(Color.clear)
						.listRowSeparator(.hidden)

					if location.isCurrent && viewModel.locations.count > 1{

							Rectangle()
							.fill(foregroundColor.opacity(0.5))
								.frame(height: 0.5)
								.listRowBackground(Color.clear)
								.listRowSeparator(.hidden)



					}

				}

			}
			.scrollContentBackground(.hidden)
			.padding(.horizontal, viewModel.theme == .night ? 40 : 0)
		}.overlay(alignment: .bottomTrailing) {

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
			.padding(.horizontal, viewModel.theme == .night ? 52 : 8)

		}
	}
}
