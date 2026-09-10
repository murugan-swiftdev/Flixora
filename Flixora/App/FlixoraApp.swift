//
//  FlixoraApp.swift
//  Flixora
//
//  Created by Murugan on 18/08/26.
//

import SwiftUI
import SwiftData

@main
struct FlixoraApp: App {

    @State private var router = AppRouter()
    @State private var myListManager = MyListManager()

    // Use the singleton instance
    @State private var premiumManager = PremiumManager.shared

    @State private var notificationRouter = NotificationRouter()

    @AppStorage("flixora_dark_mode")
    private var darkMode = false

    init() {
        NotificationManager.shared.configure()
        StripeManager.shared.configure()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(router)
                .environment(myListManager)
                .environment(premiumManager)
                .environment(notificationRouter)
                .preferredColorScheme(
                    darkMode ? .dark : .light
                )
        }
        .modelContainer(
            for: [
                UserEntity.self,
                ProfileEntity.self,
                MovieEntity.self,
                WatchHistoryEntity.self,
                WatchlistEntity.self,
                SubscriptionEntity.self
            ]
        )
    }
}
