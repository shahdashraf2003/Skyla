//
//  LoadingView.swift
//  Skyla
//
//  Created by ITI_JETS on 05/06/2026.
//

import SwiftUI

struct LoadingView: View {
    let backgroundImage: String
    let foregroundColor: Color

    @State private var isReady = false

    var body: some View {
        ZStack {
            Image(backgroundImage)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .blur(radius: isReady ? 0 : 18)
                .scaleEffect(isReady ? 1 : 1.05) // prevents blur edge bleed
                .animation(.easeInOut(duration: 1.2), value: isReady)

            VStack(spacing: 12) {
                Image(systemName: "cloud.sun.fill")
                    .font(.system(size: 52))
                    .symbolEffect(.pulse)
                    .foregroundColor(foregroundColor)

                Text("Loading...")
                    .font(.callout)
                    .foregroundColor(foregroundColor.opacity(0.7))
            }
        }
        .onAppear {
            isReady = true
        }
    }
}