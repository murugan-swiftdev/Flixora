//
//  HomeView.swift
//  Flixora
//
//  Created by Murugan on 18/08/26.
//

import SwiftUI

struct HomeView: View {

    @State private var viewModel = HomeViewModel()

    var body: some View {

        ScrollView(.vertical, showsIndicators: false) {

            LazyVStack(alignment: .leading, spacing: 30) {

                // MARK: - Hero

                if let hero = viewModel.heroContents.first {

                    HeroSectionView(content: hero)
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
                        title: "Sports",
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
            }
            .padding(.bottom, 100)
        }
        .background(Color(.systemBackground))
        .task {
            viewModel.loadHome()
        }
    }
}



struct HeroSectionView: View {

    let content: OTTContent

    @State private var showPlayer = false
    @State private var showSubscription = false
    
    @Environment(PremiumManager.self)
    private var premiumManager

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            Text(content.title)
                .font(.largeTitle.bold())
                .foregroundStyle(.white)

            Text(content.description)
                .foregroundStyle(.white.opacity(0.8))

            Button {

                print("🔥🔥🔥 HERO BUTTON WORKS 🔥🔥🔥")

                if content.isPremium {

                    if premiumManager.isPremium {

                        print("💎 USER HAS PREMIUM")
                        print("▶️ PLAYING PREMIUM CONTENT")

                        showPlayer = true

                    } else {

                        print("🔒 PREMIUM REQUIRED")

                        showSubscription = true
                    }

                } else {

                    print("▶️ FREE CONTENT")

                    showPlayer = true
                }

            } label: {

                HStack(spacing: 8) {

                    Image(
                        systemName: "play.fill"
                    )

                    Text("WATCH NOW")
                        .font(.headline.bold())
                }
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(.white)
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .contentShape(Rectangle())

            Button {
                print("MY LIST TAPPED")
            } label: {

                Text("MY LIST")
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(.gray.opacity(0.3))
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            Color(.secondarySystemBackground)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
        .padding(.horizontal)

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
}


// MARK: - Content Section

enum ContentCardStyle {
    case poster
    case ranking
    case continueWatching
    case sports
}

struct ContentSectionView: View {

    let title: String
    let contents: [OTTContent]
    let style: ContentCardStyle

    var body: some View {

        VStack(alignment: .leading, spacing: 14) {

            // MARK: - Section Header

            HStack {

                HStack(spacing: 8) {

                    if title == "Trending Now" {
                        Image(systemName: "flame.fill")
                            .foregroundStyle(.red)
                    }

                    Text(title)
                        .font(.title3.bold())
                        .foregroundStyle(.black)
                }

                Spacer()

                Button {
                    // TODO: Navigate to See All
                } label: {

                    HStack(spacing: 4) {

                        Text("See All")

                        Image(
                            systemName: "chevron.right"
                        )
                        .font(.caption2)
                    }
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.red)
                }
            }
            .padding(.horizontal)

            // MARK: - Horizontal Content

            ScrollView(
                .horizontal,
                showsIndicators: false
            ) {

                LazyHStack(spacing: 14) {

                    ForEach(
                        Array(contents.enumerated()),
                        id: \.element.id
                    ) { index, content in

                        ContentCardView(
                            content: content,
                            style: style,
                            index: index
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}


// MARK: - Content Card

struct ContentCardView: View {

    let content: OTTContent
    let style: ContentCardStyle
    let index: Int

    @State private var showPlayer = false
    @State private var showSubscription = false

    @Environment(PremiumManager.self)
    private var premiumManager

    var body: some View {

        Group {

            if style == .continueWatching {
                continueWatchingCard
            } else {
                standardContentCard
            }
        }
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
}

// MARK: - Continue Watching

private extension ContentCardView {

    var continueWatchingCard: some View {

        Button {
            playContent()
        } label: {

            VStack(
                alignment: .leading,
                spacing: 8
            ) {

                ZStack {

                    Image(content.posterName)
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: 230,
                            height: 130
                        )
                        .clipped()

                    LinearGradient(
                        colors: [
                            .clear,
                            .black.opacity(0.65)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )

                    Circle()
                        .fill(.black.opacity(0.65))
                        .frame(
                            width: 54,
                            height: 54
                        )
                        .overlay {

                            Image(
                                systemName: "play.fill"
                            )
                            .font(
                                .system(
                                    size: 20,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(.white)
                            .offset(x: 2)
                        }

                    // Premium badge

                    if content.isPremium {

                        VStack {

                            HStack {

                                Spacer()

                                Image(
                                    systemName: "crown.fill"
                                )
                                .font(.caption)
                                .foregroundStyle(.yellow)
                                .padding(7)
                                .background(
                                    .black.opacity(0.7)
                                )
                                .clipShape(Circle())
                                .padding(8)
                            }

                            Spacer()
                        }
                    }

                    // Watching progress

                    VStack {

                        Spacer()

                        GeometryReader { geometry in

                            ZStack(alignment: .leading) {

                                Rectangle()
                                    .fill(
                                        .white.opacity(0.3)
                                    )
                                    .frame(height: 4)

                                Rectangle()
                                    .fill(.red)
                                    .frame(
                                        width:
                                            geometry.size.width * 0.45,
                                        height: 4
                                    )
                            }
                        }
                        .frame(height: 4)
                    }
                }
                .frame(
                    width: 230,
                    height: 130
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 14
                    )
                )

                Text(content.title)
                    .font(
                        .subheadline.weight(
                            .semibold
                        )
                    )
                    .foregroundStyle(.black)
                    .lineLimit(1)

                HStack(spacing: 6) {

                    Image(
                        systemName: "star.fill"
                    )
                    .font(.caption2)

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

                    Text("•")

                    Text("45% watched")
                }
                .font(.caption2)
                .foregroundStyle(.secondary)
            }
            .frame(width: 230)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Standard Cards
// Trending / Popular Movies / Popular Series / Sports

private extension ContentCardView {

    var standardContentCard: some View {

        Button {
            playContent()
        } label: {

            VStack(
                alignment: .leading,
                spacing: 7
            ) {

                ZStack(alignment: .bottomLeading) {

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

                    // Title + Metadata

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
                            .font(.caption2)

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
                    .padding(8)

                    // Ranking number

                    if style == .ranking {

                        Text(
                            "\(index + 1)"
                        )
                        .font(
                            .system(
                                size: 54,
                                weight: .black
                            )
                        )
                        .foregroundStyle(.white)
                        .shadow(radius: 5)
                        .padding(8)
                    }

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
                                    .black.opacity(0.65)
                                )
                                .clipShape(Circle())
                                .padding(8)
                            }

                            Spacer()
                        }
                    }
                }
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 14
                    )
                )
            }
            .frame(width: cardWidth)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Playback

private extension ContentCardView {

    func playContent() {

        print(
            "🎬 Flixora Content Tapped:",
            content.title
        )

        if content.isPremium {

            if premiumManager.isPremium {

                print(
                    "💎 Premium active - Playing:",
                    content.title
                )

                showPlayer = true

            } else {

                print(
                    "🔒 Premium required:",
                    content.title
                )

                showSubscription = true
            }

        } else {

            print(
                "▶️ Free content - Playing:",
                content.title
            )

            showPlayer = true
        }
    }
}

// MARK: - Card Sizes

private extension ContentCardView {

    var cardWidth: CGFloat {

        switch style {

        case .continueWatching:
            return 230

        case .poster:
            return 135

        case .ranking:
            return 150

        case .sports:
            return 180
        }
    }

    var cardHeight: CGFloat {

        switch style {

        case .continueWatching:
            return 130

        case .poster:
            return 200

        case .ranking:
            return 210

        case .sports:
            return 120
        }
    }
}

