//
//  RootView.swift
//  Skyla
//
//  Created by Shahudaa on 06/06/2026.
//


import SwiftUI

struct RootView: View {

	let factory: ViewModelFactoryProtocol

    @State private var showSplash = true

    var body: some View {

        Group {

            if showSplash {

                SplashView()

            } else {

                HomeView(
                    viewModel: factory.makeHomeViewModel()
                )
            }
        }
        .task {

			try? await Task.sleep(for: .seconds(2.5))

            withAnimation(.easeInOut(duration: 0.5)) {
                showSplash = false
            }
        }
    }
}
