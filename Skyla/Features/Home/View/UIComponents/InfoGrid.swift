//
//  InfoGrid.swift
//  Skyla
//
//  Created by Shahudaa on 27/05/2026.
//

import SwiftUI


struct infoGrid:  View {
	let infoItems : [InfoItem]
	let foregroundColor : Color
	var horizontalPadding: CGFloat {
		foregroundColor == .black ? 45 : 80
	}
	var body : some View{
		LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
			ForEach(infoItems) { item in
				InfoCard(title: item.title,
						 value: item.value,
						 foreground: foregroundColor)
			}
		}
		.padding(.horizontal,horizontalPadding)
	}

}
