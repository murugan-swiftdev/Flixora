//
//  MovieDetailsViewModel.swift
//  Flixora
//
//  Created by Murugan on 18/08/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class MovieDetailsViewModel {

    let content: OTTContent

    var showSubscription = false

    var showPlayer = false

    var isInWatchlist = false

    init(content: OTTContent) {
        self.content = content
    }

    // MARK: - Watch Now

    func watchNow() {

        if content.isPremium {

            showSubscription = true

        } else {

            showPlayer = true
        }
    }

    // MARK: - Watchlist

    func toggleWatchlist() {

        isInWatchlist.toggle()
    }
}
