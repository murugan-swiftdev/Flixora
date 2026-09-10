//
//  AppRouter.swift
//  Flixora
//
//  Created by Murugan on 18/08/26.
//

import Foundation
import Observation

@Observable
final class AppRouter {

    enum Route {
        case splash
        case login
        case otp
        case home
        case movies
        case sports
        case search
        case watchlist
        case profile
    }

    var route: Route = .splash

    var loginMobileNumber = ""

    // MARK: - Authentication

    func showLogin() {

        loginMobileNumber = ""

        route = .login
    }

    func showOTP(
        mobileNumber: String
    ) {

        loginMobileNumber = mobileNumber

        route = .otp
    }

    func showHome() {

        route = .home
    }

    // MARK: - Logout

    func logout() {

        AuthViewModel.logout()

        loginMobileNumber = ""

        route = .login
    }

    // MARK: - Main Navigation

    func showMovies() {

        route = .movies
    }

    func showSports() {

        route = .sports
    }

    func showSearch() {

        route = .search
    }

    func showWatchlist() {

        route = .watchlist
    }

    func showProfile() {

        route = .profile
    }
}
