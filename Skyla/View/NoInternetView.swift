//
//  File.swift
//  Skyla
//
//  Created by Shahudaa on 31/05/2026.
//

import SwiftUI
struct NoInternetView:  View {
	let retry: () async -> Void
	let foregroundColor : Color

	var body : some View {
		VStack(spacing: 16) {
			Image(systemName: "wifi.slash")
				.font(.system(size: 62))
				.opacity(0.5)

			Text("No Internet Connection")
				.font(.title3)
				.fontWeight(.semibold)

			Text("Please check your connection and try again")
				.font(.headline)
				.opacity(0.7)
			Button {
				Task { await retry() }
			} label: {
				Text("Retry")
					.padding(.horizontal, 16)
					.padding(.vertical, 8)
					.background(foregroundColor.opacity(0.09))
					.foregroundColor(foregroundColor)
					.cornerRadius(8)
			}


		}.foregroundColor(foregroundColor)
	}
}

