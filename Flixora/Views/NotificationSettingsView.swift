//
//  NotificationSettingsView.swift
//  Flixora
//
//  Created by Murugan on 21/08/26.
//

import SwiftUI
import UserNotifications

struct NotificationSettingsView: View {

    // MARK: - App Settings

    @AppStorage("flixora_notifications_enabled")
    private var notificationsEnabled = true

    @AppStorage("flixora_notify_new_releases")
    private var newReleases = true

    @AppStorage("flixora_notify_trending")
    private var trending = true

    @AppStorage("flixora_notify_sports")
    private var sports = true

    @AppStorage("flixora_notify_continue_watching")
    private var continueWatching = true

    @AppStorage("flixora_notify_subscription")
    private var subscription = true

    // MARK: - State

    @State
    private var authorizationStatus: UNAuthorizationStatus = .notDetermined

    @State
    private var showPermissionAlert = false

    @State
    private var showTestMessage = false

    @Environment(\.scenePhase)
    private var scenePhase

    // MARK: - Body

    var body: some View {

        ScrollView(
            .vertical,
            showsIndicators: false
        ) {

            VStack(
                alignment: .leading,
                spacing: 24
            ) {

                masterNotificationSection

                testNotificationButton

                flixoraNotificationTestSection

                notificationCategoriesSection

                infoSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)

        .task {
            await refreshAuthorizationStatus()
        }

        .onChange(of: scenePhase) { _, newPhase in

            guard newPhase == .active else {
                return
            }

            Task {
                await refreshAuthorizationStatus()
            }
        }

        .alert(
            "Notifications Are Disabled",
            isPresented: $showPermissionAlert
        ) {

            Button("Open Settings") {
                NotificationManager.shared.openAppSettings()
            }

            Button("Cancel", role: .cancel) {}

        } message: {

            Text(
                "Notifications are disabled for Flixora in iPhone Settings. Enable them to receive alerts."
            )
        }
    }
}

// MARK: - Master Notifications

private extension NotificationSettingsView {

    var masterNotificationSection: some View {

        VStack(
            alignment: .leading,
            spacing: 14
        ) {

            sectionTitle(
                "Notification Settings",
                icon: "bell.fill"
            )

            HStack(spacing: 14) {

                ZStack {

                    Circle()
                        .fill(
                            Color.red.opacity(0.12)
                        )
                        .frame(
                            width: 44,
                            height: 44
                        )

                    Image(
                        systemName:
                            notificationsEnabled
                            ? "bell.fill"
                            : "bell.slash.fill"
                    )
                    .foregroundStyle(.red)
                }

                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {

                    Text("Allow Notifications")
                        .font(.headline)

                    Text(
                        authorizationStatus == .denied
                        ? "Notifications are disabled in iPhone Settings."
                        : notificationsEnabled
                        ? "You will receive Flixora notifications."
                        : "All Flixora notifications are disabled."
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }

                Spacer()

                if authorizationStatus == .denied {

                    Button {

                        NotificationManager.shared
                            .openAppSettings()

                    } label: {

                        HStack(spacing: 6) {

                            Text("Open Settings")
                                .font(
                                    .caption.weight(
                                        .semibold
                                    )
                                )
                                .foregroundStyle(.red)

                            Image(
                                systemName:
                                    "chevron.right"
                            )
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        }
                    }

                } else {

                    Toggle(
                        "",
                        isOn: Binding(
                            get: {
                                notificationsEnabled
                            },
                            set: { value in
                                handleNotificationToggle(value)
                            }
                        )
                    )
                    .labelsHidden()
                    .tint(.red)
                }
            }
            .padding(16)
            .background(
                Color.gray.opacity(0.10)
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 16
                )
            )
        }
    }
}

// MARK: - Test Notification Button

private extension NotificationSettingsView {

    var testNotificationButton: some View {

        Button {

            handleTestNotification()

        } label: {

            HStack(spacing: 12) {

                Image(
                    systemName:
                        "bell.badge.fill"
                )
                .foregroundStyle(.red)

                VStack(
                    alignment: .leading,
                    spacing: 3
                ) {

                    Text("Send Test Notification")
                        .font(
                            .subheadline.weight(
                                .semibold
                            )
                        )

                    Text(
                        "Check that Flixora notifications are working."
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }

                Spacer()

                Image(
                    systemName:
                        "chevron.right"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .padding(16)
            .background(
                Color.gray.opacity(0.10)
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 16
                )
            )
        }
        .buttonStyle(.plain)
        .opacity(
            notificationsEnabled
            ? 1
            : 0.45
        )
    }
}

// MARK: - Flixora Test Notifications

private extension NotificationSettingsView {

    var flixoraNotificationTestSection: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            sectionTitle(
                "Test Notifications",
                icon: "bell.badge.fill"
            )

            VStack(spacing: 0) {

                notificationTestRow(
                    icon: "film.fill",
                    title: "New Release Test"
                ) {

                    NotificationManager.shared
                        .sendNewReleaseNotification()

                    showTestMessage = true
                }

                Divider()
                    .padding(.leading, 58)

                notificationTestRow(
                    icon: "sportscourt.fill",
                    title: "Sports Test"
                ) {

                    NotificationManager.shared
                        .sendSportsNotification()

                    showTestMessage = true
                }

                Divider()
                    .padding(.leading, 58)

                notificationTestRow(
                    icon: "play.fill",
                    title: "Continue Watching Test"
                ) {

                    NotificationManager.shared
                        .sendContinueWatchingNotification()

                    showTestMessage = true
                }

                Divider()
                    .padding(.leading, 58)

                notificationTestRow(
                    icon: "creditcard.fill",
                    title: "Subscription Test"
                ) {

                    NotificationManager.shared
                        .sendSubscriptionNotification()

                    showTestMessage = true
                }

                Divider()
                    .padding(.leading, 58)

                notificationTestRow(
                    icon: "flame.fill",
                    title: "Trending Test"
                ) {

                    NotificationManager.shared
                        .sendTrendingNotification()

                    showTestMessage = true
                }
            }
            .background(
                Color.gray.opacity(0.10)
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 16
                )
            )
        }
        // IMPORTANT:
        // Do NOT disable this section based on
        // authorizationStatus.
        .opacity(
            notificationsEnabled
            ? 1
            : 0.45
        )
    }

    func notificationTestRow(
        icon: String,
        title: String,
        action: @escaping () -> Void
    ) -> some View {

        Button {

            action()

        } label: {

            HStack(spacing: 14) {

                Image(systemName: icon)
                    .font(.system(size: 17))
                    .foregroundStyle(.red)
                    .frame(width: 30)

                Text(title)
                    .font(
                        .subheadline.weight(
                            .semibold
                        )
                    )

                Spacer()

                Image(
                    systemName:
                        "chevron.right"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            .frame(height: 58)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(!notificationsEnabled)
    }
}

// MARK: - Categories

private extension NotificationSettingsView {

    var notificationCategoriesSection: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            sectionTitle(
                "Notification Types",
                icon: "slider.horizontal.3"
            )

            VStack(spacing: 0) {

                notificationRow(
                    icon: "film.fill",
                    title: "New Releases",
                    subtitle:
                        "Get notified about new movies and series.",
                    isOn: $newReleases
                )

                Divider()
                    .padding(.leading, 58)

                notificationRow(
                    icon: "flame.fill",
                    title: "Trending Now",
                    subtitle:
                        "Stay updated with popular content.",
                    isOn: $trending
                )

                Divider()
                    .padding(.leading, 58)

                notificationRow(
                    icon: "sportscourt.fill",
                    title: "Sports & Live Events",
                    subtitle:
                        "Get alerts for live and upcoming sports.",
                    isOn: $sports
                )

                Divider()
                    .padding(.leading, 58)

                notificationRow(
                    icon: "play.fill",
                    title: "Continue Watching",
                    subtitle:
                        "Reminders about unfinished content.",
                    isOn: $continueWatching
                )

                Divider()
                    .padding(.leading, 58)

                notificationRow(
                    icon: "creditcard.fill",
                    title: "Subscription",
                    subtitle:
                        "Payment and subscription updates.",
                    isOn: $subscription
                )
            }
            .background(
                Color.gray.opacity(0.10)
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 16
                )
            )
        }
        .disabled(!notificationsEnabled)
        .opacity(
            notificationsEnabled
            ? 1
            : 0.45
        )
    }
}

// MARK: - Notification Row

private extension NotificationSettingsView {

    func notificationRow(
        icon: String,
        title: String,
        subtitle: String,
        isOn: Binding<Bool>
    ) -> some View {

        HStack(spacing: 14) {

            Image(systemName: icon)
                .font(.system(size: 17))
                .foregroundStyle(.red)
                .frame(width: 30)

            VStack(
                alignment: .leading,
                spacing: 3
            ) {

                Text(title)
                    .font(
                        .subheadline.weight(
                            .semibold
                        )
                    )

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer()

            Toggle(
                "",
                isOn: isOn
            )
            .labelsHidden()
            .tint(.red)
        }
        .padding(.horizontal, 16)
        .frame(minHeight: 72)
    }
}

// MARK: - Info

private extension NotificationSettingsView {

    var infoSection: some View {

        HStack(
            alignment: .top,
            spacing: 12
        ) {

            Image(
                systemName:
                    "info.circle.fill"
            )
            .foregroundStyle(.red)

            Text(
                "You can change these preferences at any time. " +
                "Some important account notifications may still be sent."
            )
            .font(.caption)
            .foregroundStyle(.secondary)
            .fixedSize(
                horizontal: false,
                vertical: true
            )

            Spacer()
        }
        .padding(16)
        .background(
            Color.gray.opacity(0.08)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 14
            )
        )
    }
}

// MARK: - Section Title

private extension NotificationSettingsView {

    func sectionTitle(
        _ title: String,
        icon: String
    ) -> some View {

        HStack(spacing: 8) {

            Image(systemName: icon)
                .foregroundStyle(.red)

            Text(title)
                .font(.title3.bold())
        }
    }
}

// MARK: - Authorization

private extension NotificationSettingsView {

    func refreshAuthorizationStatus() async {

        authorizationStatus =
            await NotificationManager.shared
                .authorizationStatus()
    }

    func handleNotificationToggle(
        _ enabled: Bool
    ) {

        guard enabled else {

            notificationsEnabled = false

            NotificationManager.shared
                .setNotificationsEnabled(false)

            return
        }

        Task {

            let status =
                await NotificationManager.shared
                    .authorizationStatus()

            switch status {

            case .notDetermined:

                let granted =
                    await NotificationManager.shared
                        .requestPermission()

                let newStatus =
                    await NotificationManager.shared
                        .authorizationStatus()

                authorizationStatus = newStatus

                if granted {

                    notificationsEnabled = true

                    NotificationManager.shared
                        .setNotificationsEnabled(true)

                } else {

                    notificationsEnabled = false

                    showPermissionAlert = true
                }

            case .denied:

                notificationsEnabled = false

                authorizationStatus = .denied

                showPermissionAlert = true

            case .authorized,
                 .provisional:

                notificationsEnabled = true

                authorizationStatus = status

                NotificationManager.shared
                    .setNotificationsEnabled(true)

            default:

                notificationsEnabled = false

                authorizationStatus = status
            }
        }
    }
}

// MARK: - Test Handling

private extension NotificationSettingsView {

    func handleTestNotification() {

        guard notificationsEnabled else {
            return
        }

        switch authorizationStatus {

        case .authorized,
             .provisional:

            NotificationManager.shared
                .sendTestNotification()

            showTestMessage = true

        case .notDetermined:

            Task {

                let granted =
                    await NotificationManager.shared
                        .requestPermission()

                authorizationStatus =
                    await NotificationManager.shared
                        .authorizationStatus()

                if granted {

                    notificationsEnabled = true

                    NotificationManager.shared
                        .setNotificationsEnabled(true)

                    NotificationManager.shared
                        .sendTestNotification()

                    showTestMessage = true

                } else {

                    showPermissionAlert = true
                }
            }

        case .denied:

            showPermissionAlert = true

        default:

            showPermissionAlert = true
        }
    }
}
