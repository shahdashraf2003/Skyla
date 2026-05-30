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
}
