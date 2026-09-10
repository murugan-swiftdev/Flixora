//
//  NotificationManager.swift
//  Flixora
//
//  Created by Murugan on 21/08/26.
//

import Foundation
import UserNotifications
import UIKit

@MainActor
final class NotificationManager {

    static let shared = NotificationManager()

    private init() {}

    // MARK: - Keys

    private enum Keys {

        static let master =
            "flixora_notifications_enabled"

        static let newReleases =
            "flixora_notify_new_releases"

        static let trending =
            "flixora_notify_trending"

        static let sports =
            "flixora_notify_sports"

        static let continueWatching =
            "flixora_notify_continue_watching"

        static let subscription =
            "flixora_notify_subscription"
    }

    // MARK: - Notification Identifiers

    private enum IDs {

        static let test =
            "flixora.notification.test"

        static let newRelease =
            "flixora.notification.newRelease"

        static let trending =
            "flixora.notification.trending"

        static let sports =
            "flixora.notification.sports"

        static let continueWatching =
            "flixora.notification.continueWatching"

        static let subscription =
            "flixora.notification.subscription"
    }

    // MARK: - Setup

    func configure() {

        UNUserNotificationCenter.current().delegate =
            NotificationDelegate.shared
    }

    // MARK: - Authorization

    func authorizationStatus() async -> UNAuthorizationStatus {

        let settings =
            await UNUserNotificationCenter.current()
                .notificationSettings()

        return settings.authorizationStatus
    }

    func requestPermission() async -> Bool {

        do {

            let granted =
                try await UNUserNotificationCenter.current()
                    .requestAuthorization(
                        options: [
                            .alert,
                            .badge,
                            .sound
                        ]
                    )

            if granted {

                UIApplication.shared
                    .registerForRemoteNotifications()
            }

            return granted

        } catch {

            print(
                "❌ Notification permission error:",
                error.localizedDescription
            )

            return false
        }
    }

    // MARK: - Settings

    func openAppSettings() {

        guard let url = URL(
            string: UIApplication.openSettingsURLString
        ) else {
            return
        }

        UIApplication.shared.open(url)
    }

    // MARK: - Master Toggle

    func setNotificationsEnabled(
        _ enabled: Bool
    ) {

        UserDefaults.standard.set(
            enabled,
            forKey: Keys.master
        )

        print(
            enabled
                ? "🔔 All notifications ENABLED"
                : "🔕 All notifications DISABLED"
        )

        if !enabled {

            cancelAllNotifications()
        }
    }

    // MARK: - Category Toggle

    func setNewReleasesEnabled(
        _ enabled: Bool
    ) {

        setCategory(
            enabled,
            key: Keys.newReleases,
            identifier: IDs.newRelease,
            name: "New Releases"
        )
    }

    func setTrendingEnabled(
        _ enabled: Bool
    ) {

        setCategory(
            enabled,
            key: Keys.trending,
            identifier: IDs.trending,
            name: "Trending"
        )
    }

    func setSportsEnabled(
        _ enabled: Bool
    ) {

        setCategory(
            enabled,
            key: Keys.sports,
            identifier: IDs.sports,
            name: "Sports"
        )
    }

    func setContinueWatchingEnabled(
        _ enabled: Bool
    ) {

        setCategory(
            enabled,
            key: Keys.continueWatching,
            identifier: IDs.continueWatching,
            name: "Continue Watching"
        )
    }

    func setSubscriptionEnabled(
        _ enabled: Bool
    ) {

        setCategory(
            enabled,
            key: Keys.subscription,
            identifier: IDs.subscription,
            name: "Subscription"
        )
    }

    private func setCategory(
        _ enabled: Bool,
        key: String,
        identifier: String,
        name: String
    ) {

        UserDefaults.standard.set(
            enabled,
            forKey: key
        )

        if enabled {

            print(
                "🔔 \(name) ENABLED"
            )

        } else {

            print(
                "🔕 \(name) DISABLED"
            )

            UNUserNotificationCenter.current()
                .removePendingNotificationRequests(
                    withIdentifiers: [identifier]
                )

            UNUserNotificationCenter.current()
                .removeDeliveredNotifications(
                    withIdentifiers: [identifier]
                )
        }
    }

    // MARK: - Current Settings

    private var masterEnabled: Bool {

        UserDefaults.standard.object(
            forKey: Keys.master
        ) as? Bool ?? true
    }

    private var newReleasesEnabled: Bool {

        UserDefaults.standard.object(
            forKey: Keys.newReleases
        ) as? Bool ?? true
    }

    private var trendingEnabled: Bool {

        UserDefaults.standard.object(
            forKey: Keys.trending
        ) as? Bool ?? true
    }

    private var sportsEnabled: Bool {

        UserDefaults.standard.object(
            forKey: Keys.sports
        ) as? Bool ?? true
    }

    private var continueWatchingEnabled: Bool {

        UserDefaults.standard.object(
            forKey: Keys.continueWatching
        ) as? Bool ?? true
    }

    private var subscriptionEnabled: Bool {

        UserDefaults.standard.object(
            forKey: Keys.subscription
        ) as? Bool ?? true
    }

    // MARK: - Test

    func sendTestNotification() {

        guard masterEnabled else {

            print(
                "🚫 Test blocked - master notifications OFF"
            )

            return
        }

        scheduleNotification(
            identifier: IDs.test,
            title: "Flixora",
            body: "Your Flixora notifications are working!",
            type: nil
        )
    }

    // MARK: - New Release

    func sendNewReleaseNotification() {

        guard masterEnabled else {

            print(
                "🚫 New Release blocked - master OFF"
            )

            return
        }

        guard newReleasesEnabled else {

            print(
                "🚫 New Release blocked - category OFF"
            )

            return
        }

        scheduleNotification(
            identifier: IDs.newRelease,
            title: "🎬 New Release",
            body: "A new movie is now streaming on Flixora.",
            type: .newRelease
        )
    }

    // MARK: - Trending

    func sendTrendingNotification() {

        guard masterEnabled else {

            print(
                "🚫 Trending blocked - master OFF"
            )

            return
        }

        guard trendingEnabled else {

            print(
                "🚫 Trending blocked - category OFF"
            )

            return
        }

        scheduleNotification(
            identifier: IDs.trending,
            title: "🔥 Trending Now",
            body: "Check out what's trending on Flixora.",
            type: .trending
        )
    }

    // MARK: - Sports

    func sendSportsNotification() {

        guard masterEnabled else {

            print(
                "🚫 Sports blocked - master OFF"
            )

            return
        }

        guard sportsEnabled else {

            print(
                "🚫 Sports blocked - category OFF"
            )

            return
        }

        scheduleNotification(
            identifier: IDs.sports,
            title: "⚽ Live Sports",
            body: "A live sports event is starting soon.",
            type: .sports
        )
    }

    // MARK: - Continue Watching

    func sendContinueWatchingNotification() {

        guard masterEnabled else {

            print(
                "🚫 Continue Watching blocked - master OFF"
            )

            return
        }

        guard continueWatchingEnabled else {

            print(
                "🚫 Continue Watching blocked - category OFF"
            )

            return
        }

        scheduleNotification(
            identifier: IDs.continueWatching,
            title: "▶️ Continue Watching",
            body: "Continue watching where you left off.",
            type: .continueWatching
        )
    }

    // MARK: - Subscription

    func sendSubscriptionNotification() {

        guard masterEnabled else {

            print(
                "🚫 Subscription blocked - master OFF"
            )

            return
        }

        guard subscriptionEnabled else {

            print(
                "🚫 Subscription blocked - category OFF"
            )

            return
        }

        scheduleNotification(
            identifier: IDs.subscription,
            title: "💳 Subscription",
            body: "Check your Flixora subscription details.",
            type: .subscription
        )
    }

    // MARK: - Schedule

    private func scheduleNotification(
        identifier: String,
        title: String,
        body: String,
        type: FlixoraNotificationType?
    ) {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1

        if let type {
            content.userInfo = [
                FlixoraNotificationKeys.type: type.rawValue
            ]
        }

        // Remove an existing notification with the same ID first.
        center.removePendingNotificationRequests(
            withIdentifiers: [identifier]
        )

        // Fire after 5 seconds.
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 5,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )

        center.add(request) { error in
            if let error {
                print(
                    "❌ Notification scheduling failed:",
                    error.localizedDescription
                )
                return
            }

            print("✅ Notification scheduled:", title)

            // Verify that iOS actually has the request.
            center.getPendingNotificationRequests { requests in
                let exists = requests.contains {
                    $0.identifier == identifier
                }

                print(
                    exists
                        ? "✅ Pending notification verified"
                        : "❌ Notification NOT found in pending requests"
                )
            }
        }
    }

    // MARK: - Cancel All

    func cancelAllNotifications() {

        UNUserNotificationCenter.current()
            .removeAllPendingNotificationRequests()

        UNUserNotificationCenter.current()
            .removeAllDeliveredNotifications()

        print(
            "🗑️ All Flixora notifications cancelled"
        )
    }

    // MARK: - Clear Badge

    func clearBadge() {

        UNUserNotificationCenter.current()
            .setBadgeCount(0)
    }
}

// MARK: - Notification Delegate

final class NotificationDelegate:
    NSObject,
    UNUserNotificationCenterDelegate {

    static let shared = NotificationDelegate()

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {

        print(
            "🔔 Foreground notification:",
            notification.request.content.title
        )

        return [
            .banner,
            .sound,
            .badge
        ]
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {

        let userInfo =
            response.notification
                .request
                .content
                .userInfo

        let type =
            userInfo[
                FlixoraNotificationKeys.type
            ] as? String

        print(
            "🔔 Notification tapped:",
            type ?? "unknown"
        )

        NotificationCenter.default.post(
            name: .flixoraNotificationTapped,
            object: nil,
            userInfo: userInfo
        )
    }
}
