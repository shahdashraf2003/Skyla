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
	let factory  = AppContainer.shared.makeFactory()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
			SavedLocation.self,
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
				viewModel: factory.makeHomeViewModel()
			)

		}
        .modelContainer(sharedModelContainer)
    }
}
