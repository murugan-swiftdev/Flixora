//
//  HomeViewModel.swift
//  Flixora
//
//  Created by Murugan on 18/08/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class HomeViewModel {

    var heroContents: [OTTContent] = []
    var continueWatching: [OTTContent] = []
    var trending: [OTTContent] = []
    var popularMovies: [OTTContent] = []
    var popularSeries: [OTTContent] = []
    var sports: [OTTContent] = []
    var tamilContents: [OTTContent] = []
    var hindiContents: [OTTContent] = []
    var englishContents: [OTTContent] = []

    var isLoading = false

    func loadHome() {

        isLoading = true

        heroContents = MockContentData.hero
        continueWatching = MockContentData.continueWatching
        trending = MockContentData.trending
        popularMovies = MockContentData.popularMovies
        popularSeries = MockContentData.popularSeries
        sports = MockContentData.sports
        tamilContents = MockContentData.tamil
        hindiContents = MockContentData.hindi
        englishContents = MockContentData.english

        isLoading = false
    }
}
