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
							.foregroundColor(.orange)
							.fontWeight(.heavy)
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
						.foregroundColor(foregroundColor)


                }
            }
        }
        .foregroundColor(foregroundColor)
		.padding()
		.background(
			RoundedRectangle(cornerRadius: 16)
				.fill(foregroundColor.opacity(0.08))
		)

    }
}
