//
//  SplashView.swift
//  Skyla
//
//  Created by Shahudaa on 06/06/2026.
//

import SwiftUI

struct SplashView: View {

	@State private var scale: CGFloat = 0.3
	@State private var rotation: Double = -20
	@State private var opacity: Double = 0
	@State private var glow = false

	var body: some View {

		ZStack {

			LinearGradient(
				colors: [
					Color.blue,
					Color.cyan
				],
				startPoint: .topLeading,
				endPoint: .bottomTrailing
			)
			.ignoresSafeArea()

			VStack(spacing: 24) {

				Image("sunny")
					.resizable()
					.scaledToFit()
					.frame(width: 200)
					.scaleEffect(scale)
					.rotationEffect(.degrees(rotation))
					.shadow(
						color: .white.opacity(glow ? 0.9 : 0.2),
						radius: glow ? 40 : 5
					)

				Text("Skyla")
					.font(.system(size: 42, weight: .black))
					.foregroundColor(.white)
					.opacity(opacity)
			}
		}
		.onAppear {

			withAnimation(
				.spring(
					response: 0.7,
					dampingFraction: 0.55
				)
			) {
				scale = 1
				rotation = 0
				opacity = 1
			}

			withAnimation(
				.easeInOut(duration: 1)
				.repeatForever(autoreverses: true)
			) {
				glow = true
			}
		}
	}
}
