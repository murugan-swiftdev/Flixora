//
//  HomeContent.swift
//  Flixora
//
//  Created by Murugan on 18/08/26.
//

import Foundation

enum ContentType: String, Codable {
    case movie
    case series
    case sports
}

struct OTTContent: Identifiable, Codable {

    let id: UUID

    let title: String
    let posterName: String
    let backdropName: String
    let description: String
    let rating: Double
    let releaseYear: Int
    let genre: String
    let duration: Int
    let language: String
    let isPremium: Bool
    // Keep your existing property
        let contentType: ContentType


    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        posterName: String,
        backdropName: String,
        contentType: ContentType,
        language: String,
        genre: String,
        releaseYear: Int,
        duration: Int,
        rating: Double,
        isPremium: Bool
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.posterName = posterName
        self.backdropName = backdropName
        self.contentType = contentType
        self.language = language
        self.genre = genre
        self.releaseYear = releaseYear
        self.duration = duration
        self.rating = rating
        self.isPremium = isPremium
    }
}
