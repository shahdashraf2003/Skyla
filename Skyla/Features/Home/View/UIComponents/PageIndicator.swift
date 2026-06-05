//
//  File.swift
//  Skyla
//
//  Created by ITI_JETS on 05/06/2026.
//


private var pageIndicator: some View {
		HStack(spacing: 6) {
			ForEach(Array(viewModel.allLocations.enumerated()), id: \.offset) { index, location in
				if location.isCurrent {
					Image(systemName: "location.fill")
						.font(.system(size: 8))
						.foregroundColor(
							index == viewModel.currentLocationIndex
							? foregroundColor
							: foregroundColor.opacity(0.4)
						)
				} else {
					Circle()
						.fill(
							index == viewModel.currentLocationIndex
							? foregroundColor
							: foregroundColor.opacity(0.4)
						)
						.frame(width: 8, height: 8)
				}
			}
		}
		.padding(.horizontal, 12)
		.padding(.vertical, 6)
		.background(
			Capsule().fill(foregroundColor.opacity(0.15))
		)
	}