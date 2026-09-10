//
//  MoviesViewModel.swift
//  Flixora
//
//  Created by Murugan on 18/08/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class MoviesViewModel {

    var selectedLanguage = "All"
    var selectedGenre = "All"
    var searchText = ""

    // Trimmed search text to avoid repeated trimming in views
    var trimmedSearch: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var isSearchEmpty: Bool {
        trimmedSearch.isEmpty
    }

    let languages = [
        "All",
        "Tamil",
        "Hindi",
        "English",
        "Telugu",
        "Malayalam",
        "Kannada"
    ]

    let genres = [
        "All",
        "Action",
        "Comedy",
        "Drama",
        "Thriller",
        "Romance",
        "Sci-Fi"
    ]

    var movies: [OTTContent] = []

    init() {
        loadMovies()
    }

    func loadMovies() {

        movies =
            MockContentData.trending
            + MockContentData.popularMovies
            + MockContentData.tamil
            + MockContentData.hindi
            + MockContentData.english
    }

    var filteredMovies: [OTTContent] {

        // Use the reusable search helper to keep filtering logic consistent
        searchContents(
            movies,
            query: searchText,
            selectedLanguage: selectedLanguage,
            selectedGenre: selectedGenre,
            deduplicate: false
        )
    }

    var trendingMovies: [OTTContent] {

        movies.filter {
            $0.rating >= 8.5
        }
    }

    var topRatedMovies: [OTTContent] {

        movies.sorted {
            $0.rating > $1.rating
        }
    }

    var newReleases: [OTTContent] {

        movies.filter {
            $0.releaseYear >= 2026
        }
    }
}
