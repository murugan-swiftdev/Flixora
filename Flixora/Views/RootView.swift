//
//  RootView.swift
//  Flixora
//
//  Created by Murugan on 18/08/26.
//
import SwiftUI
import SwiftData

struct RootView: View {

    @Environment(AppRouter.self)
    private var router

    @Environment(\.modelContext)
    private var modelContext
    
    @Environment(NotificationRouter.self)
    private var notificationRouter

    var body: some View {

        Group {

            switch router.route {

            // MARK: - Splash

            case .splash:

                SplashView()

            // MARK: - Authentication

            case .login:

                LoginView()

            case .otp:

                OTPVerificationView(
                    mobileNumber: router.loginMobileNumber
                )

            // MARK: - Main App

            case .home:

                HomePlaceholderView()

            case .movies:

                MoviesView()

            case .sports:

                Text("Sports")
                    .navigationTitle("Sports")

            case .search:

                SearchView()

            case .watchlist:

                MySpaceView()

            case .profile:

                MySpaceView()
            }
        }
        .animation(
            .easeInOut(duration: 0.25),
            value: router.route
        )
        .onReceive(
            NotificationCenter.default.publisher(
                for: .flixoraNotificationTapped
            )
        ) { notification in

            guard
                let userInfo =
                    notification.userInfo,
                let typeString =
                    userInfo[
                        FlixoraNotificationKeys.type
                    ] as? String,
                let type =
                    FlixoraNotificationType(
                        rawValue: typeString
                    )
            else {
                return
            }

            notificationRouter
                .selectedNotificationType = type
        }
    }
}
