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

    var body: some View {
        List(viewModel.locations) { location in
            Text(location.name)
        }
        .onAppear {
            viewModel.load()
        }
    }
}
