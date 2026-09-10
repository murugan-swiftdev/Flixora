//
//  WatchHistoryEntity.swift
//  Flixora
//
//  Created by Murugan on 18/08/26.
//

import Foundation
import SwiftData

@Model
final class WatchHistoryEntity {

    @Attribute(.unique)
    var id: UUID

    var movieID: UUID
    var profileID: UUID

    var watchedDuration: Double
    var totalDuration: Double
    var lastWatchedAt: Date

    init(
        id: UUID = UUID(),
        movieID: UUID,
        profileID: UUID,
        watchedDuration: Double = 0,
        totalDuration: Double = 0,
        lastWatchedAt: Date = .now
    ) {
        self.id = id
        self.movieID = movieID
        self.profileID = profileID
        self.watchedDuration = watchedDuration
        self.totalDuration = totalDuration
        self.lastWatchedAt = lastWatchedAt
    }

    var progress: Double {

        guard totalDuration > 0 else {
            return 0
        }

        return min(watchedDuration / totalDuration, 1)
    }
}
