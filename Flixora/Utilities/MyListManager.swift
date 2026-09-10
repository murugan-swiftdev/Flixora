//
//  MyListManager.swift
//  Flixora
//
//  Created by Murugan on 19/08/26.
//

import Foundation
import SwiftData
import Observation

@MainActor
@Observable
final class MyListManager {

    private(set) var items: [OTTContent] = []

    private var modelContext: ModelContext?

    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext

        if let modelContext {
            load(context: modelContext)
        }
    }

    // MARK: - Configure

    func configure(context: ModelContext) {
        self.modelContext = context
        load(context: context)
    }

    // MARK: - Reload

    func reload() {
        guard let modelContext else {
            return
        }

        load(context: modelContext)
    }

    // MARK: - Contains

    func contains(_ content: OTTContent) -> Bool {

        guard let modelContext else {
            return false
        }

        let contentID = content.id
        let profileID = currentProfileID

        let descriptor = FetchDescriptor<WatchlistEntity>(
            predicate: #Predicate<WatchlistEntity> {
                $0.movieID == contentID &&
                $0.profileID == profileID
            }
        )

        do {

            return try !modelContext
                .fetch(descriptor)
                .isEmpty

        } catch {

            print(
                "❌ WATCHLIST CONTAINS ERROR:",
                error
            )

            return false
        }
    }

    // MARK: - Toggle

    func toggle(_ content: OTTContent) {

        if contains(content) {
            remove(content)
        } else {
            add(content)
        }

        reload()
    }

    // MARK: - Add

    func add(_ content: OTTContent) {

        guard let modelContext else {
            print("❌ MyListManager has no ModelContext")
            return
        }

        guard !contains(content) else {
            return
        }

        let entity = WatchlistEntity(
            movieID: content.id,
            profileID: currentProfileID
        )

        modelContext.insert(entity)

        do {
            try modelContext.save()

            print("✅ WATCHLIST SAVED:", content.title)

            reload()

        } catch {
            print("❌ WATCHLIST SAVE ERROR:", error)
        }
    }

    // MARK: - Remove

    func remove(_ content: OTTContent) {

        guard let modelContext else {
            print("❌ MyListManager has no ModelContext")
            return
        }

        let contentID = content.id
        let profileID = currentProfileID

        let descriptor = FetchDescriptor<WatchlistEntity>(
            predicate: #Predicate<WatchlistEntity> {
                $0.movieID == contentID &&
                $0.profileID == profileID
            }
        )

        do {

            let entities = try modelContext.fetch(descriptor)

            for entity in entities {
                modelContext.delete(entity)
            }

            try modelContext.save()

            print(
                "🗑️ WATCHLIST REMOVED:",
                content.title
            )

            reload()

        } catch {

            print(
                "❌ WATCHLIST REMOVE ERROR:",
                error
            )
        }
    }

    // MARK: - Load

    private func load(context: ModelContext) {

        let profileID = currentProfileID

        let descriptor = FetchDescriptor<WatchlistEntity>(
            predicate: #Predicate<WatchlistEntity> {
                $0.profileID == profileID
            },
            sortBy: [
                SortDescriptor(
                    \.addedAt,
                    order: .reverse
                )
            ]
        )

        do {

            let watchlistEntities =
                try context.fetch(descriptor)

            let allContents =
                allAvailableContents

            items = watchlistEntities.compactMap { entity in

                allContents.first {
                    $0.id == entity.movieID
                }
            }

            print(
                "✅ MY LIST LOADED:",
                items.map(\.title)
            )

        } catch {

            print(
                "❌ MY LIST LOAD ERROR:",
                error
            )

            items = []
        }
    }

    // MARK: - Current Profile

    private var currentProfileID: UUID {

        if let storedID = UserDefaults.standard.string(
            forKey: "flixora.currentProfileID"
        ),
        let uuid = UUID(uuidString: storedID) {

            return uuid
        }

        let newID = UUID()

        UserDefaults.standard.set(
            newID.uuidString,
            forKey: "flixora.currentProfileID"
        )

        return newID
    }

    // MARK: - All Content

    private var allAvailableContents: [OTTContent] {

        var contents: [OTTContent] = []

        contents += MockContentData.hero
        contents += MockContentData.continueWatching
        contents += MockContentData.trending
        contents += MockContentData.popularMovies
        contents += MockContentData.popularSeries
        contents += MockContentData.sports
        contents += MockContentData.tamil
        contents += MockContentData.hindi
        contents += MockContentData.english

        var seen = Set<UUID>()

        return contents.filter { content in
            seen.insert(content.id).inserted
        }
    }
}
