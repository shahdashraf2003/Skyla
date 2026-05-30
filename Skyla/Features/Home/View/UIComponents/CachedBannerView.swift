	//
	//  CachedBannerView.swift
	//  Skyla
	//
	//  Created by Shahudaa on 27/05/2026.
	//


import SwiftUI

struct CachedBannerView: View {

	var body: some View {

		HStack(spacing: 8) {
			Image(systemName: "wifi.slash")
			Text("Showing cached weather data")
		}
		.font(.caption)
		.padding(.horizontal, 8)
		.padding(.vertical, 8)
		.background(.ultraThinMaterial)
		.clipShape(Capsule())
		.padding(.top, 50)
	}
}
