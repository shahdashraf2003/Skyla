//
//  SuggestedCityCard.swift
//  Skyla
//
//  Created by ITI_JETS on 02/06/2026.
//


import SwiftUI


struct SuggestedCityCard: View {

    let title: String
    let foregroundColor: Color
    let action: () -> Void

    var body: some View {

        Button(action: action) {

            HStack(spacing: 4) {

                Image(systemName: "sparkles")
                    .font(.caption)

                Text(title)
                    .font(.subheadline.weight(.medium))
            }
            .foregroundColor(foregroundColor)
            .padding(.horizontal, 6)
            .padding(.vertical,4)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
        }
    }
}
