//
//  SuggestedCityCardImproved.swift
//  Skyla
//
//  Created by ITI_JETS on 02/06/2026.
//


import SwiftUI


struct SuggestedCityCardImproved: View {

    let title: String
    let foregroundColor: Color
    let action: () -> Void

    var body: some View {

        Button(action: action) {

            HStack(spacing: 8) {

                Image(systemName: "sparkles")
                    .font(.caption)

                Text(title)
                    .font(.subheadline.weight(.medium))
            }
            .foregroundColor(foregroundColor)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
        }
    }
}
