	//
	//  CachedBannerView.swift
	//  Skyla
	//
	//  Created by Shahudaa on 27/05/2026.
	//


import SwiftUI

struct CachedBannerView: View {
	let foreground :Color
	let backgound : Color
	var body: some View {

		HStack(spacing: 8) {
			Image(systemName: "wifi.slash")
			Text("Showing cached weather data")
		}
		.foregroundColor(foreground)
		.font(.caption)
		.padding(.horizontal, 8)
		.padding(.vertical, 8)
		.background(backgound)
		.clipShape(Capsule())
		.padding(.top, 50)
	}
}
