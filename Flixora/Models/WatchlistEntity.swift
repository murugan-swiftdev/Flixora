//
//  WatchlistEntity.swift
//  Flixora
//
//  Created by Murugan on 18/08/26.
//

import Foundation
import SwiftData

@Model
final class WatchlistEntity {

    @Attribute(.unique)
    var id: UUID

    var movieID: UUID
    var profileID: UUID
    var addedAt: Date

    init(
        id: UUID = UUID(),
        movieID: UUID,
        profileID: UUID,
        addedAt: Date = .now
    ) {
        self.id = id
        self.movieID = movieID
        self.profileID = profileID
        self.addedAt = addedAt
    }
}
