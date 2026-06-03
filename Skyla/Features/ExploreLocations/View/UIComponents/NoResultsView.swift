//
//  NoResultsView.swift
//  Skyla
//
//  Created by ITI_JETS on 03/06/2026.
//

import SwiftUI


struct NoResultsView: View {
    let query: String
    let foregroundColor: Color

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 44))
                .opacity(0.4)
            Text("No results for \(query)")
                .font(.headline)
            Text("Try a different city name or spelling.")
                .font(.subheadline)
                .opacity(0.6)
                .multilineTextAlignment(.center)
        }
        .foregroundColor(foregroundColor)
        .padding(.top, 60)
        .padding(.horizontal, 32)
    }
}
