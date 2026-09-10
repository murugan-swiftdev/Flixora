//
//  HomePlaceholderView.swift
//  Flixora
//
//  Created by Murugan on 18/08/26.
//

import SwiftUI

struct HomePlaceholderView: View {

    @Environment(AppRouter.self)
    private var router
    
    @AppStorage("flixora_profile_image")
    private var profileImageData = Data()

    @State private var viewModel = HomeViewModel()

    @State private var selectedHero = 0
    
    @State private var selectedTab: OTTTab = .home

    var body: some View {

        NavigationStack {

            ZStack(alignment: .bottom) {

                tabContent

                OTTTabBar(
                    selectedTab: $selectedTab
                )
            }
        }
        .task {
            viewModel.loadHome()
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: .flixoraNotificationTapped
            )
        ) { notification in

            guard let userInfo =
                    notification.userInfo
            else {
                print("❌ No notification userInfo")
                return
            }

            guard let typeString =
                    userInfo[
                        FlixoraNotificationKeys.type
                    ] as? String
            else {
                print("❌ Notification type missing")
                return
            }

            guard let type =
                    FlixoraNotificationType(
                        rawValue: typeString
                    )
            else {
                print(
                    "❌ Unknown notification type:",
                    typeString
                )
                return
            }

            print(
                "📲 HomePlaceholder received:",
                type.rawValue
            )

            switch type {

            case .newRelease:
                print("🎬 Opening Movies")
                selectedTab = .movies

            case .trending:
                print("🔥 Opening Home")
                selectedTab = .home

            case .sports:
                print("⚽ Opening Sports")
                selectedTab = .sports

            case .continueWatching:
                print("▶️ Opening Continue Watching")
                selectedTab = .home

            case .subscription:
                print("💳 Opening My Space")
                selectedTab = .mySpace
            }
        }
    }
    
    @ViewBuilder
    private var tabContent: some View {

        switch selectedTab {

        case .home:

            homeTab

        case .movies:

            MoviesView()

        case .sports:

            NavigationStack {
                SportsView()
            }

        case .search:

            SearchView()

        case .mySpace:

            MySpaceView()
        }
    }

    // MARK: - Home

    // MARK: - Home

    private var homeTab: some View {

        ScrollView(
            .vertical,
            showsIndicators: false
        ) {

            LazyVStack(
                alignment: .leading,
                spacing: 30
            ) {

                // MARK: - Header

                header

                // MARK: - Hero

                if let hero = viewModel.heroContents.first {
                    HeroSectionView(
                        content: hero
                    )
                }

                // MARK: - Continue Watching

                if !viewModel.continueWatching.isEmpty {
                    ContentSectionView(
                        title: "Continue Watching",
                        contents: viewModel.continueWatching,
                        style: .continueWatching
                    )
                }

                // MARK: - Trending

                if !viewModel.trending.isEmpty {
                    ContentSectionView(
                        title: "Trending Now",
                        contents: viewModel.trending,
                        style: .ranking
                    )
                }

                // MARK: - Popular Movies

                if !viewModel.popularMovies.isEmpty {
                    ContentSectionView(
                        title: "Popular Movies",
                        contents: viewModel.popularMovies,
                        style: .poster
                    )
                }

                // MARK: - Popular Series

                if !viewModel.popularSeries.isEmpty {
                    ContentSectionView(
                        title: "Popular Series",
                        contents: viewModel.popularSeries,
                        style: .poster
                    )
                }

                // MARK: - Sports

                if !viewModel.sports.isEmpty {
                    ContentSectionView(
                        title: "Live & Upcoming Sports",
                        contents: viewModel.sports,
                        style: .poster
                    )
                }

                // MARK: - Tamil

                if !viewModel.tamilContents.isEmpty {
                    ContentSectionView(
                        title: "Tamil",
                        contents: viewModel.tamilContents,
                        style: .poster
                    )
                }

                // MARK: - Hindi

                if !viewModel.hindiContents.isEmpty {
                    ContentSectionView(
                        title: "Hindi",
                        contents: viewModel.hindiContents,
                        style: .poster
                    )
                }

                // MARK: - English

                if !viewModel.englishContents.isEmpty {
                    ContentSectionView(
                        title: "English",
                        contents: viewModel.englishContents,
                        style: .poster
                    )
                }

                // Space for custom tab bar

                Spacer()
                    .frame(height: 100)
            }
            .padding(.top, 8)
        }
        .background(Color(.systemBackground))
    }

    // MARK: - Header

    private var header: some View {

        HStack(spacing: 16) {

            VStack(alignment: .leading, spacing: 2) {

                HStack(spacing: 6) {

                    Image(systemName: "play.tv.fill")
                        .foregroundStyle(.red)

                    Text("FLIXORA")
                        .font(
                            .system(
                                size: 22,
                                weight: .black
                            )
                        )
                }

                Text("Movies • Series • Sports")
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button {

                selectedTab = .search

            } label: {

                Image(systemName: "magnifyingglass")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(width: 40, height: 40)
                    .background(.gray.opacity(0.12))
                    .clipShape(Circle())
            }

            Button {

            } label: {

                Image(systemName: "bell")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(width: 40, height: 40)
                    .background(.gray.opacity(0.12))
                    .clipShape(Circle())
            }

            Button {
                selectedTab = .mySpace
            } label: {

                Group {

                    if let image = UIImage(
                        data: profileImageData
                    ) {

                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()

                    } else {

                        Image(
                            systemName:
                                "person.crop.circle.fill"
                        )
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.red)
                        .padding(2)
                    }
                }
                .frame(
                    width: 36,
                    height: 36
                )
                .clipShape(Circle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    // MARK: - Hero

    // MARK: - Hero

    private var heroSection: some View {

        Group {

            if let hero = viewModel.heroContents.first {

                PremiumHeroSectionView(
                    content: hero
                )
            }
        }
    }
    
    // MARK: - Notification Navigation

    private func handleNotificationNavigation(
        _ notification: Notification
    ) {

        guard let userInfo =
                notification.userInfo
        else {
            print("❌ Notification userInfo missing")
            return
        }

        guard let typeString =
                userInfo[
                    FlixoraNotificationKeys.type
                ] as? String
        else {
            print("❌ Notification type missing")
            return
        }

        guard let type =
                FlixoraNotificationType(
                    rawValue: typeString
                )
        else {
            print(
                "❌ Unknown notification type:",
                typeString
            )
            return
        }

        print(
            "📲 Handling notification:",
            type.rawValue
        )

        switch type {

        case .newRelease:

            print("🎬 Opening Movies")
            selectedTab = .movies

        case .trending:

            print("🔥 Opening Home")
            selectedTab = .home

        case .sports:

            print("⚽ Opening Sports")
            selectedTab = .sports

        case .continueWatching:

            print("▶️ Opening Continue Watching")
            selectedTab = .home

        case .subscription:

            print("💳 Opening My Space")
            selectedTab = .mySpace
        }
    }
}

// MARK: - Premium Hero

struct PremiumHeroSectionView: View {

    let content: OTTContent

    @State private var showPlayer = false
    @State private var showSubscription = false

    var body: some View {

        ZStack(alignment: .bottomLeading) {

            // MARK: Background

            Image(content.posterName)
                .resizable()
                .scaledToFill()
                .frame(
                    maxWidth: .infinity,
                    minHeight: 480,
                    maxHeight: 540
                )
                .clipped()

            // MARK: Top Gradient

            LinearGradient(
                colors: [
                    .black.opacity(0.05),
                    .black.opacity(0.25),
                    .black.opacity(0.85),
                    .black
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            // MARK: Content

            VStack(
                alignment: .leading,
                spacing: 14
            ) {

                Spacer()

                // Premium badge

                if content.isPremium {

                    HStack(spacing: 6) {

                        Image(systemName: "crown.fill")

                        Text("PREMIUM")
                            .font(
                                .system(
                                    size: 10,
                                    weight: .bold
                                )
                            )
                    }
                    .foregroundStyle(.yellow)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        .black.opacity(0.65)
                    )
                    .clipShape(Capsule())
                }

                // Title

                Text(content.title)
                    .font(
                        .system(
                            size: 34,
                            weight: .black
                        )
                    )
                    .foregroundStyle(.white)
                    .lineLimit(2)

                // Metadata

                HStack(spacing: 8) {

                    Text("\(content.releaseYear)")

                    Text("•")

                    HStack(spacing: 3) {

                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)

                        Text(
                            String(
                                format: "%.1f",
                                content.rating
                            )
                        )
                    }

                    Text("•")

                    Text("HD")
                        .fontWeight(.semibold)
                }
                .font(.caption)
                .foregroundStyle(
                    .white.opacity(0.85)
                )

                // Description

                Text(content.description)
                    .font(.subheadline)
                    .foregroundStyle(
                        .white.opacity(0.78)
                    )
                    .lineLimit(3)

                // Buttons

                HStack(spacing: 12) {

                    Button {

                        if content.isPremium {
                            showSubscription = true
                        } else {
                            showPlayer = true
                        }

                    } label: {

                        HStack(spacing: 8) {

                            Image(
                                systemName: "play.fill"
                            )

                            Text("Watch Now")
                        }
                        .font(
                            .subheadline.bold()
                        )
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(.white)
                        .clipShape(Capsule())
                    }

                    Button {

                        print(
                            "❤️ My List:",
                            content.title
                        )

                    } label: {

                        Image(
                            systemName: "plus"
                        )
                        .font(
                            .system(
                                size: 18,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.white)
                        .frame(
                            width: 52,
                            height: 48
                        )
                        .background(
                            .white.opacity(0.18)
                        )
                        .clipShape(Circle())
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 480,
            maxHeight: 540
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 24
            )
        )
        .padding(.horizontal, 12)

        // MARK: Player

        .fullScreenCover(
            isPresented: $showPlayer
        ) {

            FlixoraVideoPlayerView(
                content: PlayerContent(
                    title: content.title,
                    videoName: "flixora_demo"
                )
            )
        }

        // MARK: Subscription

        .fullScreenCover(
            isPresented: $showSubscription
        ) {

            SubscriptionView()
        }
    }
}

// MARK: - Premium Content Card

struct PremiumContentCard: View {

    let content: OTTContent
    let style: ContentCardStyle
    let index: Int

    @State private var showPlayer = false
    @State private var showSubscription = false

    var body: some View {

        Button {

            if content.isPremium {
                showSubscription = true
            } else {
                showPlayer = true
            }

        } label: {

            VStack(
                alignment: .leading,
                spacing: 7
            ) {

                ZStack(
                    alignment: .bottomLeading
                ) {

                    // Poster

                    Image(content.posterName)
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: cardWidth,
                            height: cardHeight
                        )
                        .clipped()

                    // Bottom gradient

                    LinearGradient(
                        colors: [
                            .clear,
                            .black.opacity(0.85)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )

                    // Ranking

                    if style == .ranking {

                        Text("\(index + 1)")
                            .font(
                                .system(
                                    size: 62,
                                    weight: .black
                                )
                            )
                            .foregroundStyle(.white)
                            .shadow(
                                color: .black,
                                radius: 5
                            )
                            .padding(8)
                    }

                    // Content information

                    VStack(
                        alignment: .leading,
                        spacing: 4
                    ) {

                        Spacer()

                        Text(content.title)
                            .font(
                                .caption.bold()
                            )
                            .foregroundStyle(.white)
                            .lineLimit(2)

                        HStack(spacing: 5) {

                            Image(
                                systemName:
                                    "star.fill"
                            )
                            .foregroundStyle(
                                .yellow
                            )

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
                        .font(.caption2)
                        .foregroundStyle(
                            .white.opacity(0.8)
                        )
                    }
                    .padding(9)

                    // Premium badge

                    if content.isPremium {

                        VStack {

                            HStack {

                                Spacer()

                                Image(
                                    systemName:
                                        "crown.fill"
                                )
                                .font(.caption)
                                .foregroundStyle(
                                    .yellow
                                )
                                .padding(7)
                                .background(
                                    .black.opacity(0.7)
                                )
                                .clipShape(
                                    Circle()
                                )
                                .padding(8)
                            }

                            Spacer()
                        }
                    }

                    // Sports LIVE badge

                    if style == .sports {

                        VStack {

                            HStack {

                                HStack(spacing: 5) {

                                    Circle()
                                        .fill(.red)
                                        .frame(
                                            width: 6,
                                            height: 6
                                        )

                                    Text("LIVE")
                                        .font(
                                            .system(
                                                size: 9,
                                                weight: .bold
                                            )
                                        )
                                }
                                .foregroundStyle(.white)
                                .padding(
                                    .horizontal,
                                    8
                                )
                                .padding(
                                    .vertical,
                                    5
                                )
                                .background(
                                    .red
                                )
                                .clipShape(
                                    Capsule()
                                )
                                .padding(8)

                                Spacer()
                            }

                            Spacer()
                        }
                    }
                }
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 16
                    )
                )

                // Continue watching

                if style == .continueWatching {

                    ProgressView(
                        value: 0.45
                    )
                    .tint(.red)
                    .frame(
                        width: cardWidth
                    )

                    Text("45% watched")
                        .font(.caption2)
                        .foregroundStyle(
                            .white.opacity(0.5)
                        )
                }
            }
        }
        .buttonStyle(.plain)

        .fullScreenCover(
            isPresented: $showPlayer
        ) {

            FlixoraVideoPlayerView(
                content: PlayerContent(
                    title: content.title,
                    videoName: "flixora_demo"
                )
            )
        }

        .fullScreenCover(
            isPresented: $showSubscription
        ) {

            SubscriptionView()
        }
    }

    private var cardWidth: CGFloat {

        switch style {

        case .continueWatching:
            return 190

        case .ranking:
            return 150

        case .sports:
            return 150

        case .poster:
            return 135
        }
    }

    private var cardHeight: CGFloat {

        switch style {

        case .continueWatching:
            return 110

        case .ranking:
            return 215

        case .sports:
            return 200

        case .poster:
            return 200
        }
    }
}
