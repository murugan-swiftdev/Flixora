//
//  MockContentData.swift
//  Flixora
//
//  Created by Murugan on 18/08/26.
//

import Foundation

enum MockContentData {

    // MARK: - Stable IDs

    private static let lastHorizonID =
        UUID(uuidString: "11111111-1111-1111-1111-111111111111")!

    private static let shadowWarriorID =
        UUID(uuidString: "22222222-2222-2222-2222-222222222222")!

    private static let darkCityID =
        UUID(uuidString: "33333333-3333-3333-3333-333333333333")!

    // MARK: - Content

    static let lastHorizon = OTTContent(
        id: lastHorizonID,
        title: "The Last Horizon",
        description: "A thrilling journey.",
        posterName: "poster_1",
        backdropName: "hero_1",
        contentType: .movie,
        language: "English",
        genre: "Sci-Fi",
        releaseYear: 2026,
        duration: 138,
        rating: 8.7,
        isPremium: true
    )

    static let shadowWarrior = OTTContent(
        id: shadowWarriorID,
        title: "Shadow Warrior",
        description: "An action movie.",
        posterName: "poster_2",
        backdropName: "hero_1",
        contentType: .movie,
        language: "Tamil",
        genre: "Action",
        releaseYear: 2026,
        duration: 145,
        rating: 8.4,
        isPremium: true
    )

    static let darkCity = OTTContent(
        id: darkCityID,
        title: "Dark City",
        description: "A thriller series.",
        posterName: "poster_1",
        backdropName: "hero_1",
        contentType: .series,
        language: "English",
        genre: "Thriller",
        releaseYear: 2026,
        duration: 48,
        rating: 8.2,
        isPremium: false
    )

    // MARK: - Hero

    static let hero: [OTTContent] = [
        lastHorizon
    ]

    // MARK: - Continue Watching

    static let continueWatching: [OTTContent] = [
        darkCity
    ]

    // MARK: - Trending

    static let trending: [OTTContent] = [
        lastHorizon,
        shadowWarrior
    ]

    // MARK: - Categories

    static let popularMovies: [OTTContent] = [
        lastHorizon,
        shadowWarrior
    ]

    static let popularSeries: [OTTContent] = [
        darkCity
    ]

    static let sports: [OTTContent] = [
        shadowWarrior
    ]

    static let tamil: [OTTContent] = [
        shadowWarrior
    ]

    static let hindi: [OTTContent] = [
        lastHorizon
    ]

    static let english: [OTTContent] = [
        lastHorizon,
        darkCity
    ]

    // MARK: - All Content

    static let allContents: [OTTContent] = [

        lastHorizon,
        shadowWarrior,
        darkCity
    ]
}
