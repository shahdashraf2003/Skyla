//
//  LocationChip.swift
//  Skyla
//
//  Created by Shahudaa on 31/05/2026.
//

import SwiftUI


struct LocationChip: View {

    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.2))
                .clipShape(Capsule())
        }
    }
}
