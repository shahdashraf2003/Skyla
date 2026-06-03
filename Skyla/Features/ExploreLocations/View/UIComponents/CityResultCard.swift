//
//  CityResultCardImproved.swift
//  Skyla
//
//  Created by ITI_JETS on 02/06/2026.
//


import SwiftUI


struct CityResultCard: View {

    let item: City
    let foregroundColor: Color
    let action: () -> Void

    var body: some View {

        Button(action: action) {

            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 44, height: 44)

                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(foregroundColor)
                }

                VStack(alignment: .leading, spacing: 4) {

                    Text(item.name)
                        .font(.headline)
                        .foregroundColor(foregroundColor)

                    Text(item.country)
                        .font(.caption)
                        .foregroundColor(foregroundColor.opacity(0.6))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .opacity(0.5)
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}
