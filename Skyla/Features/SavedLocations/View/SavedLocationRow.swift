//
//  SavedLocationRow.swift
//  Skyla
//
//  Created by Shahudaa on 30/05/2026.
//

import SwiftUI


struct SavedLocationRow: View {

    let location: SavedLocation
    let foregroundColor: Color
    let deleteAction: () -> Void

    var body: some View {

        HStack {

            VStack(alignment: .leading, spacing: 4) {

                HStack {

                    Text(location.name)
                        .font(.headline)

					if location.isCurrent{

                        Image(systemName: "location.fill")
                            .foregroundColor(.blue)
                    }
                }

                if location.isCurrent {

                    Text("Current Location")
                        .font(.caption)
                        .opacity(0.7)
                }
            }

            Spacer()

            if !location.isCurrent {

                Button(role: .destructive) {
                    deleteAction()
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
        .foregroundColor(foregroundColor)
        .padding(.vertical, 8)
    }
}
