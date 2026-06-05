//
//  LoadingView.swift
//  Skyla
//
//  Created by ITI_JETS on 05/06/2026.
//

import SwiftUI
import Combine

struct LoadingView: View {
   
    let foregroundColor: Color

    @State private var isReady = false
    @State private var iconScale: CGFloat = 0.6
    @State private var iconOpacity: CGFloat = 0
    @State private var textOpacity: CGFloat = 0
    @State private var dotCount = 0

    private let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {

            VStack(spacing: 12) {
                Image(systemName: "cloud.sun.fill")
                    .font(.system(size: 52))
                    .symbolEffect(.pulse)
                    .foregroundColor(foregroundColor)
                    .scaleEffect(iconScale)
                    .opacity(iconOpacity)

                Text("Loading\(dots)")
                    .font(.callout)
                    .foregroundColor(foregroundColor.opacity(0.7))
                    .opacity(textOpacity)
                    .animation(.easeInOut(duration: 0.2), value: dotCount)
            }
        }
        .onAppear {
            isReady = true

            withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.2)) {
                iconScale = 1.0
                iconOpacity = 1
            }

            withAnimation(.easeIn(duration: 0.4).delay(0.5)) {
                textOpacity = 1
            }
        }
        .onReceive(timer) { _ in
            dotCount = (dotCount + 1) % 4
        }
    }

    private var dots: String {
        String(repeating: ".", count: dotCount)
    }
}

#Preview {
    LoadingView( foregroundColor: .black)
}
