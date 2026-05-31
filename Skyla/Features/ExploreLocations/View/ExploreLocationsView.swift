//
//  ExploreLocationsView.swift
//  Skyla
//
//  Created by Shahudaa on 31/05/2026.
//


import SwiftUI

struct ExploreLocationsView: View {

    @StateObject var viewModel: ExploreLocationsViewModel



	var body: some View {
		VStack(spacing: 16) {
			
			
			TextField("Search city...", text: $viewModel.query)
				.textFieldStyle(.roundedBorder)
				.padding()
			
			
			ScrollView(.horizontal, showsIndicators: false) {
					HStack {
							ForEach(viewModel.suggested) { item in
								LocationChip(title: item.name) {
									//onSelectLocation(item)
								}
							}
				}.padding(.horizontal)
				 }
				 
				 
				 List(viewModel.results) { item in
					 VStack(alignment: .leading) {
							Text(item.name)
							Text("\(item.country)")
								.font(.caption)
								.foregroundColor(.gray)
				 }.onTapGesture {
					 //viewModel. o
					//nSelectLocation(item)
				 }
			}
		}.navigationTitle("Explore Locations")

	}


}
