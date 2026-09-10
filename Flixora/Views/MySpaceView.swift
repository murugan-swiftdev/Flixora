//
//  MySpaceView.swift
//  Flixora
//
//  Created by Murugan on 19/08/26.
//

import SwiftUI

struct MySpaceView: View {
    
    @Environment(AppRouter.self)
    private var router

    @Environment(MyListManager.self)
    private var myListManager
    
    @AppStorage("flixora_profile_name")
    private var profileName = "Flixora User"

    @AppStorage("flixora_profile_email")
    private var profileEmail = "user@flixora.com"
    
    @AppStorage("flixora_profile_image")
    private var profileImageData = Data()
    
    @AppStorage("flixora_notifications_enabled")
    private var notifications = true
    
    @AppStorage("flixora_dark_mode")
    private var isDarkMode = false

    @AppStorage("flixora_autoplay")
    private var autoplay = true
    
    @State private var showLogoutPopup = false
    
    @State private var showNotificationSettings = false

    var body: some View {

        ScrollView(
            .vertical,
            showsIndicators: false
        ) {

            VStack(
                spacing: 22
            ) {

                profileHeader

                continueWatchingSection

                myListSection

                settingsSection

                supportSection

                logoutButton

                Spacer()
                    .frame(height: 100)
            }
            .padding(.top, 16)
        }
        .navigationTitle("My Space")
        .navigationBarTitleDisplayMode(.large)
        .overlay {

            if showLogoutPopup {

                ZStack {

                    // MARK: - Dim Background

                    Color.black
                        .opacity(0.65)
                        .ignoresSafeArea()
                        .onTapGesture {

                            withAnimation(
                                .easeInOut(duration: 0.25)
                            ) {
                                showLogoutPopup = false
                            }
                        }

                    // MARK: - Popup

                    VStack(spacing: 0) {

                        Spacer()

                        VStack(spacing: 22) {

                            // MARK: - Handle

                            Capsule()
                                .fill(
                                    Color.white.opacity(0.25)
                                )
                                .frame(
                                    width: 42,
                                    height: 5
                                )
                                .padding(.top, 10)

                            // MARK: - Icon

                            ZStack {

                                Circle()
                                    .fill(
                                        Color.red.opacity(0.15)
                                    )
                                    .frame(
                                        width: 70,
                                        height: 70
                                    )

                                Image(
                                    systemName:
                                        "rectangle.portrait.and.arrow.right"
                                )
                                .font(
                                    .system(
                                        size: 27,
                                        weight: .semibold
                                    )
                                )
                                .foregroundStyle(.red)
                            }

                            // MARK: - Title

                            VStack(spacing: 8) {

                                Text("Log out of Flixora?")
                                    .font(
                                        .system(
                                            size: 22,
                                            weight: .bold
                                        )
                                    )
                                    .foregroundStyle(.white)

                                Text(
                                    "Are you sure you want to log out of your account?"
                                )
                                .font(.subheadline)
                                .foregroundStyle(
                                    .white.opacity(0.55)
                                )
                                .multilineTextAlignment(.center)
                                .lineSpacing(3)
                            }

                            // MARK: - Buttons

                            VStack(spacing: 12) {

                                Button {

                                    withAnimation(
                                        .easeInOut(duration: 0.2)
                                    ) {
                                        showLogoutPopup = false
                                    }

                                    router.logout()

                                } label: {

                                    Text("Log Out")
                                        .font(
                                            .headline.weight(
                                                .semibold
                                            )
                                        )
                                        .foregroundStyle(.white)
                                        .frame(
                                            maxWidth: .infinity
                                        )
                                        .frame(height: 52)
                                        .background(
                                            Color.red
                                        )
                                        .clipShape(
                                            RoundedRectangle(
                                                cornerRadius: 14
                                            )
                                        )
                                }

                                Button {

                                    withAnimation(
                                        .easeInOut(duration: 0.25)
                                    ) {
                                        showLogoutPopup = false
                                    }

                                } label: {

                                    Text("Cancel")
                                        .font(
                                            .headline.weight(
                                                .medium
                                            )
                                        )
                                        .foregroundStyle(.white)
                                        .frame(
                                            maxWidth: .infinity
                                        )
                                        .frame(height: 52)
                                        .background(
                                            Color.white.opacity(0.08)
                                        )
                                        .clipShape(
                                            RoundedRectangle(
                                                cornerRadius: 14
                                            )
                                        )
                                }
                            }
                            .padding(.top, 4)
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 28)
                        .frame(
                            maxWidth: .infinity
                        )
                        .background(
                            Color(
                                red: 0.055,
                                green: 0.055,
                                blue: 0.065
                            )
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 28,
                                style: .continuous
                            )
                        )
                        .padding(.horizontal, 8)
                        .padding(.bottom, 8)
                    }
                    .transition(
                        .move(edge: .bottom)
                        .combined(
                            with: .opacity
                        )
                    )
                }
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
    
}

// MARK: - Profile

private extension MySpaceView {

    var profileHeader: some View {

        VStack(spacing: 14) {

            ZStack(alignment: .bottomTrailing) {

                profileImageView

                    .frame(
                        width: 92,
                        height: 92
                    )
                    .clipShape(Circle())

                NavigationLink {

                    EditProfileView()

                } label: {

                    ZStack {

                        Circle()
                            .fill(Color.red)
                            .frame(
                                width: 30,
                                height: 30
                            )

                        Image(
                            systemName: "pencil"
                        )
                        .font(
                            .system(
                                size: 11,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.white)
                    }
                    .overlay {

                        Circle()
                            .stroke(
                                Color(.systemBackground),
                                lineWidth: 3
                            )
                    }
                }
                .offset(
                    x: -2,
                    y: -2
                )
            }

            Text(
                profileName.isEmpty
                    ? "Flixora User"
                    : profileName
            )
            .font(.title2.bold())

            Text("Free Plan")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            NavigationLink {

                EditProfileView()

            } label: {

                HStack(spacing: 6) {

                    Image(
                        systemName: "pencil"
                    )

                    Text("Edit Profile")
                }
                .font(.subheadline.bold())
                .foregroundStyle(.red)
                .padding(.horizontal, 22)
                .padding(.vertical, 10)
                .background(
                    Color.red.opacity(0.1)
                )
                .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
    }

    @ViewBuilder
    var profileImageView: some View {

        if let image = UIImage(
            data: profileImageData
        ) {

            Image(uiImage: image)
                .resizable()
                .scaledToFill()

        } else {

            ZStack {

                Circle()
                    .fill(
                        Color.red.opacity(0.12)
                    )

                Image(
                    systemName:
                        "person.crop.circle.fill"
                )
                .font(.system(size: 82))
                .foregroundStyle(.red)
            }
        }
    }
}

// MARK: - Continue Watching

private extension MySpaceView {

    var continueWatchingSection: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            sectionTitle("Continue Watching")

            if MockContentData.continueWatching.isEmpty {

                Text(
                    "Nothing to continue watching."
                )
                .foregroundStyle(.secondary)
                .padding(.horizontal, 16)

            } else {

                ScrollView(
                    .horizontal,
                    showsIndicators: false
                ) {

                    HStack(spacing: 14) {

                        ForEach(
                            MockContentData.continueWatching
                        ) { content in

                            MySpaceContentCard(
                                content: content
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }
}

// MARK: - My List

private extension MySpaceView {

    var myListSection: some View {

        VStack(
            alignment: .leading,
            spacing: 14
        ) {

            HStack {

                Text("My List")
                    .font(.title3.bold())

                Spacer()

                if !myListManager.items.isEmpty {

                    Text(
                        "\(myListManager.items.count)"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 16)

            if myListManager.items.isEmpty {

                emptyMyListView

            } else {

                ScrollView(
                    .horizontal,
                    showsIndicators: false
                ) {

                    HStack(spacing: 14) {

                        ForEach(
                            myListManager.items
                        ) { content in

                            NavigationLink {

                                MovieDetailsView(
                                    content: content
                                )

                            } label: {

                                MyListContentCard(
                                    content: content
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }

    var emptyMyListView: some View {

        HStack(spacing: 14) {

            Image(
                systemName: "bookmark"
            )
            .font(.system(size: 26))
            .foregroundStyle(.red)

            VStack(
                alignment: .leading,
                spacing: 5
            ) {

                Text("Your List is Empty")
                    .font(.headline)

                Text(
                    "Tap + on any movie or series to save it here."
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(16)
        .background(
            Color.gray.opacity(0.1)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 16
            )
        )
        .padding(.horizontal, 16)
    }
}

// MARK: - Settings

private extension MySpaceView {

    var settingsSection: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            sectionTitle("Settings")

            VStack(spacing: 0) {

                NavigationLink {
                    NotificationSettingsView()
                } label: {
                    settingRow(
                        icon: "bell.fill",
                        title: "Notifications"
                    ) {
                        HStack(spacing: 8) {

                            Text(
                                notifications
                                    ? "On"
                                    : "Off"
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)

                            Image(
                                systemName: "chevron.right"
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                    }
                }
                .buttonStyle(.plain)

                Divider()
                    .padding(.leading, 54)

                settingRow(
                    icon: "play.fill",
                    title: "Autoplay"
                ) {
                    Toggle(
                        "",
                        isOn: $autoplay
                    )
                    .labelsHidden()
                    .tint(.red)
                }

                Divider()
                    .padding(.leading, 54)

                settingRow(
                    icon: isDarkMode ? "moon.fill" : "sun.max.fill",
                    title: isDarkMode ? "Dark Mode" : "Light Mode"
                ) {
                    Toggle(
                        "",
                        isOn: $isDarkMode
                    )
                    .labelsHidden()
                    .tint(.red)
                }

                Divider()
                    .padding(.leading, 54)

                settingRow(
                    icon: "arrow.down.circle.fill",
                    title: "Downloads"
                ) {
                    Image(
                        systemName: "chevron.right"
                    )
                    .foregroundStyle(.secondary)
                }
            }
            .background(
                Color.gray.opacity(0.1)
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 16
                )
            )
            .padding(.horizontal, 16)
        }
    }
}

// MARK: - Support

private extension MySpaceView {

    var supportSection: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            sectionTitle("Support")

            VStack(spacing: 0) {

                settingRow(
                    icon: "questionmark.circle.fill",
                    title: "Help & Support"
                ) {

                    Image(
                        systemName: "chevron.right"
                    )
                    .foregroundStyle(.secondary)
                }

                Divider()
                    .padding(.leading, 54)

                settingRow(
                    icon: "info.circle.fill",
                    title: "About Flixora"
                ) {

                    Image(
                        systemName: "chevron.right"
                    )
                    .foregroundStyle(.secondary)
                }
            }
            .background(
                Color.gray.opacity(0.1)
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 16
                )
            )
            .padding(.horizontal, 16)
        }
    }
}

// MARK: - Logout

private extension MySpaceView {

    var logoutButton: some View {

        Button {

            withAnimation(.easeInOut(duration: 0.25)) {
                showLogoutPopup = true
            }

        } label: {

            HStack(spacing: 10) {

                Image(
                    systemName:
                        "rectangle.portrait.and.arrow.right"
                )

                Text("Log Out")
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                Color.red.opacity(0.10)
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 14
                )
            )
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Section Title

private extension MySpaceView {

    func sectionTitle(
        _ title: String
    ) -> some View {

        Text(title)
            .font(.title3.bold())
            .padding(.horizontal, 16)
    }
}

// MARK: - Setting Row

private extension MySpaceView {

    func settingRow<Trailing: View>(
        icon: String,
        title: String,
        @ViewBuilder trailing: () -> Trailing
    ) -> some View {

        HStack(spacing: 14) {

            Image(systemName: icon)
                .foregroundStyle(.red)
                .frame(width: 24)

            Text(title)
                .font(.subheadline)

            Spacer()

            trailing()
        }
        .padding(.horizontal, 16)
        .frame(height: 58)
    }
}

// MARK: - Continue Watching Card

struct MySpaceContentCard: View {

    let content: OTTContent

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 6
        ) {

            Image(content.posterName)
                .resizable()
                .scaledToFill()
                .frame(
                    width: 170,
                    height: 100
                )
                .clipped()
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 12
                    )
                )

            Text(content.title)
                .font(.caption.bold())
                .lineLimit(1)

            ProgressView(value: 0.45)
                .tint(.red)
                .frame(width: 170)
        }
    }
}

// MARK: - My List Card

struct MyListContentCard: View {

    let content: OTTContent

    @Environment(MyListManager.self)
    private var myListManager

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 7
        ) {

            ZStack(
                alignment: .topTrailing
            ) {

                Image(content.posterName)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: 145,
                        height: 205
                    )
                    .clipped()
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 12
                        )
                    )

                Button {

                    myListManager.remove(content)

                } label: {

                    Image(
                        systemName:
                            "checkmark.circle.fill"
                    )
                    .font(.title2)
                    .foregroundStyle(.white)
                    .background(
                        Circle()
                            .fill(Color.red)
                    )
                }
                .padding(8)
            }

            Text(content.title)
                .font(
                    .system(
                        size: 14,
                        weight: .semibold
                    )
                )
                .foregroundStyle(.primary)
                .lineLimit(1)

            HStack(spacing: 5) {

                Image(
                    systemName: "star.fill"
                )
                .foregroundStyle(.yellow)

                Text(
                    String(
                        format: "%.1f",
                        content.rating
                    )
                )

                Text("•")

                Text(
                    "\(content.releaseYear)"
                )
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .frame(width: 145)
    }
}
