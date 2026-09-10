//
//  OTTTab.swift
//  Flixora
//
//  Created by Murugan on 18/08/26.
//

import SwiftUI

enum OTTTab: CaseIterable {

    case home
    case movies
    case sports
    case search
    case mySpace

    var title: String {

        switch self {
        case .home:
            return "Home"

        case .movies:
            return "Movies"

        case .sports:
            return "Sports"

        case .search:
            return "Search"

        case .mySpace:
            return "My Space"
        }
    }

    var icon: String {

        switch self {
        case .home:
            return "house"

        case .movies:
            return "film"

        case .sports:
            return "trophy"

        case .search:
            return "magnifyingglass"

        case .mySpace:
            return "person"
        }
    }

    var selectedIcon: String {

        switch self {
        case .home:
            return "house.fill"

        case .movies:
            return "film.fill"

        case .sports:
            return "trophy.fill"

        case .search:
            return "magnifyingglass"

        case .mySpace:
            return "person.fill"
        }
    }
}
