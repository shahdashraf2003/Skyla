//
//  EmptyStateView.swift
//  Skyla
//
//  Created by Shahudaa on 29/05/2026.
//


import SwiftUI

struct EmptyStateView: View {

    var body: some View {

        VStack(spacing: 16) {
            Image(systemName: "cloud.sun")
                .font(.system(size: 60))
            Text("No Weather Data")
                .font(.title3)
                .fontWeight(.semibold)

            Text("Try again later")
				.foregroundColor(.orange)
		}
	}
}
