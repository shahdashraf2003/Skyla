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

		let locations = (try? context.fetch(descriptor)) ?? []

		let current = locations.filter(\.isCurrent)
		let others = locations.filter { !$0.isCurrent}
		try? context.save() 
		return current + others
	}

    func add(_ item: SavedLocation) {
        context.insert(item)
		try? context.save()
    }

    func delete(_ item: SavedLocation) {
        context.delete(item)
		try? context.save()
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

	func saveCurrentLocation(
		name: String,
		lat: Double,
		lon: Double
	) {

		let descriptor = FetchDescriptor<SavedLocation>()

		guard let locations = try? context.fetch(descriptor) else {
			return
		}


		locations
			.filter { $0.isCurrent }
			.forEach { $0.isCurrent = false }


		if let existing = locations.first(
			where: {
				abs($0.lat - lat) < 0.0001 &&
				abs($0.lon - lon) < 0.0001
			}
		) {
			existing.isCurrent = true
			existing.name = name
		} else {

			let location = SavedLocation(
				name: name,
				lat: lat,
				lon: lon,
				isCurrent: true
			)

			context.insert(location)
		}

		try? context.save()
	}
}
