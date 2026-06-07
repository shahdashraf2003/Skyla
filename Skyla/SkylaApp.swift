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
	@StateObject var weatherContext = AppContainer.shared.container.resolve(WeatherContext.self)!
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

			RootView(factory: factory)
				.environmentObject(weatherContext)
		}
        .modelContainer(sharedModelContainer)
    }
}
