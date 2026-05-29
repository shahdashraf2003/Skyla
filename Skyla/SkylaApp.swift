//
//  SkylaApp.swift
//  Skyla
//
//  Created by Shahd Ashraf on 26/05/2026.
//

import SwiftUI
import SwiftData
import Swinject

@main
struct SkylaApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
			HomeView(
				viewModel: AppContainer.shared.container.resolve(HomeViewModel.self)!
			)
        }
        .modelContainer(sharedModelContainer)
    }
}
