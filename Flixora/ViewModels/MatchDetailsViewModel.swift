//
//  MatchDetailsViewModel.swift
//  Flixora
//
//  Created by Murugan on 19/08/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class MatchDetailsViewModel {

    let content: SportsContent

    var showSubscription = false
    var showPlayer = false

    var isInMyList = false

    init(content: SportsContent) {
        self.content = content
    }

    func watchNow() {

        if content.isPremium {

            showSubscription = true

        } else {

            showPlayer = true
        }
    }

    func toggleMyList() {
        isInMyList.toggle()
    }
}
