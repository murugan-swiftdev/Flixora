//
//  MovieEntity.swift
//  Flixora
//
//  Created by Murugan on 18/08/26.
//

import Foundation
import SwiftData

@Model
final class MovieEntity {

    @Attribute(.unique)
    var id: UUID

    var title: String
    var overview: String

    var posterName: String
    var backdropName: String

    var releaseYear: Int
    var duration: Int

    var rating: Double
    var ageRating: String

    var genre: String
    var language: String

    var isPremium: Bool

    init(
        id: UUID = UUID(),
        title: String,
        overview: String,
        posterName: String = "",
        backdropName: String = "",
        releaseYear: Int = 2026,
        duration: Int = 120,
        rating: Double = 0.0,
        ageRating: String = "U",
        genre: String = "Drama",
        language: String = "English",
        isPremium: Bool = false
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterName = posterName
        self.backdropName = backdropName
        self.releaseYear = releaseYear
        self.duration = duration
        self.rating = rating
        self.ageRating = ageRating
        self.genre = genre
        self.language = language
        self.isPremium = isPremium
    }
}
