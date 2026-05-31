//
//  EmptySavedLocationsView.swift
//  Skyla
//
//  Created by Shahudaa on 30/05/2026.
//

import SwiftUI

struct EmptySavedLocationsView: View {
    var foregroundColor: Color

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "mappin.slash")
                .font(.system(size: 56))
                .opacity(0.5)

            Text("No saved locations")
                .font(.title3)
                .fontWeight(.semibold)

            Text("Tap the + button to add a location")
                .font(.subheadline)
                .opacity(0.6)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 200)
        }
        .foregroundColor(foregroundColor)
    }
}
