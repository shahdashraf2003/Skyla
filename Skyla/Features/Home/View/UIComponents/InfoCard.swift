//
//  InfoCard.swift
//  Skyla
//
//  Created by Shahudaa on 27/05/2026.
//

import SwiftUI


struct InfoCard: View {
	let title: String
	let value: String
	let foreground: Color

	var body: some View {
		VStack(alignment: .leading, spacing: 6) {
			Text(title).font(.caption).opacity(0.7)
			Text(value).font(.title3).fontWeight(.semibold)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding()
		
		.background(
			RoundedRectangle(cornerRadius: 16)
				.fill(foreground.opacity(0.08))
		)
	}
}
