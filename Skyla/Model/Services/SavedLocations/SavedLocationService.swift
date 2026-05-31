//
//  SavedLocationService.swift
//  Skyla
//
//  Created by Shahudaa on 30/05/2026.
//

import SwiftData


final class SavedLocationService: SavedLocationServiceProtocol {

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetch() -> [SavedLocation] {
        let descriptor = FetchDescriptor<SavedLocation>()
        return (try? context.fetch(descriptor)) ?? []
    }

    func add(_ item: SavedLocation) {
        context.insert(item)
    }

    func delete(_ item: SavedLocation) {
        context.delete(item)
    }

	func exists(lat: Double, lon: Double) -> Bool {

		let items = fetch()

		for item in items {

			let sameLatitude = abs(item.lat - lat) < 0.0001
			let sameLongitude = abs(item.lon - lon) < 0.0001

			if sameLatitude && sameLongitude {
				return true
			}
		}

		return false
	}
}
