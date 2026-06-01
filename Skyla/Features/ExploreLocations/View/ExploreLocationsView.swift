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
			
			
			ScrollView(.vertical, showsIndicators: false) {

				let columns = [
					GridItem(.adaptive(minimum: 90), spacing: 4)
				]

				LazyVGrid(columns: columns, spacing: 12) {
					ForEach(viewModel.suggested, id: \.self) { item in
						LocationChip(title: item) {
							//viewModel.selectSuggestedCity(item)
						}
						.frame(minWidth: 80, maxWidth: .infinity)
					}
				}
				
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
