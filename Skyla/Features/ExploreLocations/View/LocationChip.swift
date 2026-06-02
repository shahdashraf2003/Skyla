//
//  LocationChip.swift
//  Skyla
//
//  Created by Shahudaa on 31/05/2026.
//

import SwiftUI


struct LocationChip: View {

    let title: String
    let foregroundColor: Color?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(foregroundColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(foregroundColor.opacity(0.08))
                .clipShape(Capsule())
        }
    }
}
