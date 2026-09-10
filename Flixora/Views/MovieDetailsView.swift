//
//  MovieDetailsView.swift
//  Flixora
//
//  Created by Murugan on 18/08/26.
//

import SwiftUI

struct MovieDetailsView: View {

    @State private var viewModel: MovieDetailsViewModel

    @Environment(\.dismiss)
    private var dismiss

    init(content: OTTContent) {
        _viewModel = State(
            initialValue: MovieDetailsViewModel(
                content: content
            )
        )
    }

    var body: some View {

        ScrollView(
            .vertical,
            showsIndicators: false
        ) {

            VStack(
                alignment: .leading,
                spacing: 24
            ) {

                heroSection
                movieInfo
                actionButtons
                descriptionSection
                castSection
                relatedSection

                Spacer()
                    .frame(height: 40)
            }
        }
        .ignoresSafeArea(edges: .top)
        .background(
            Color(.systemBackground)
        )
        .toolbar {

            ToolbarItem(
                placement: .topBarLeading
            ) {

                Button {

                    dismiss()

                } label: {

                    Image(
                        systemName:
                            "chevron.left"
                    )
                    .font(
                        .system(
                            size: 17,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.white)
                    .frame(
                        width: 38,
                        height: 38
                    )
                    .background(
                        .black.opacity(0.5)
                    )
                    .clipShape(Circle())
                }
            }
        }

        // Subscription screen
        .fullScreenCover(
            isPresented:
                $viewModel.showSubscription
        ) {

            SubscriptionView()
        }

        // Video player
        .fullScreenCover(
            isPresented:
                $viewModel.showPlayer
        ) {

            FlixoraVideoPlayerView(
                content: PlayerContent(
                    title: viewModel.content.title,
                    videoName: "flixora_demo"
                )
            )
        }
    }
}

private extension MovieDetailsView {

    var heroSection: some View {

        ZStack(alignment: .bottomLeading) {

            Image(
                viewModel.content.backdropName
            )
            .resizable()
            .scaledToFill()
            .frame(
                maxWidth: .infinity
            )
            .frame(height: 430)
            .clipped()

            LinearGradient(
                colors: [
                    .clear,
                    .black.opacity(0.35),
                    .black.opacity(0.95)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(
                alignment: .leading,
                spacing: 10
            ) {

                Spacer()

                Text(
                    viewModel.content.title
                )
                .font(
                    .system(
                        size: 34,
                        weight: .black
                    )
                )
                .foregroundStyle(.white)

                HStack(spacing: 8) {

                    Text(
                        "\(viewModel.content.releaseYear)"
                    )

                    Text("•")

                    Text(
                        viewModel.content.genre
                    )

                    Text("•")

                    Text(
                        viewModel.content.language
                    )

                    Text("•")

                    Label(
                        String(
                            format: "%.1f",
                            viewModel.content.rating
                        ),
                        systemImage: "star.fill"
                    )
                    .foregroundStyle(.yellow)
                }
                .font(.caption)
                .foregroundStyle(
                    .white.opacity(0.85)
                )
            }
            .padding(20)
        }
        .frame(height: 430)
    }
}

private extension MovieDetailsView {

    var movieInfo: some View {

        HStack(
            alignment: .top,
            spacing: 16
        ) {

            Image(
                viewModel.content.posterName
            )
            .resizable()
            .scaledToFill()
            .frame(
                width: 110,
                height: 160
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 12
                )
            )

            VStack(
                alignment: .leading,
                spacing: 10
            ) {

                Text(
                    viewModel.content.title
                )
                .font(
                    .title2
                )
                .fontWeight(.bold)

                Text(
                    "\(viewModel.content.duration) min"
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)

                Text(
                    viewModel.content.description
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(5)
            }
        }
        .padding(.horizontal, 16)
    }
}

private extension MovieDetailsView {

    var actionButtons: some View {

        HStack(spacing: 12) {

            Button {

                viewModel.watchNow()

            } label: {

                Label(
                    "Watch Now",
                    systemImage: "play.fill"
                )
                .fontWeight(.bold)
                .frame(
                    maxWidth: .infinity
                )
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)

            Button {

                viewModel.toggleWatchlist()

            } label: {

                Image(
                    systemName:
                        viewModel.isInWatchlist
                        ? "checkmark"
                        : "plus"
                )
                .fontWeight(.bold)
                .frame(
                    width: 52,
                    height: 46
                )
            }
            .buttonStyle(.bordered)
        }
        .padding(.horizontal, 16)
    }
}

private extension MovieDetailsView {

    var descriptionSection: some View {

        VStack(
            alignment: .leading,
            spacing: 10
        ) {

            Text("About this movie")
                .font(.title3)
                .fontWeight(.bold)

            Text(
                viewModel.content.description
            )
            .font(.body)
            .foregroundStyle(.secondary)
            .fixedSize(
                horizontal: false,
                vertical: true
            )
        }
        .padding(.horizontal, 16)
    }
}

private extension MovieDetailsView {

    var castSection: some View {

        VStack(
            alignment: .leading,
            spacing: 14
        ) {

            Text("Cast & Crew")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal, 16)

            ScrollView(
                .horizontal,
                showsIndicators: false
            ) {

                HStack(spacing: 16) {

                    CastCard(
                        name: "Arjun",
                        role: "Lead Actor",
                        image: "poster_1"
                    )

                    CastCard(
                        name: "Meera",
                        role: "Lead Actress",
                        image: "poster_2"
                    )

                    CastCard(
                        name: "Karthik",
                        role: "Director",
                        image: "poster_3"
                    )
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

private extension MovieDetailsView {

    var relatedSection: some View {

        VStack(
            alignment: .leading,
            spacing: 14
        ) {

            Text("More Like This")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal, 16)

            ScrollView(
                .horizontal,
                showsIndicators: false
            ) {

                HStack(spacing: 14) {

                    ForEach(
                        MockContentData.trending
                    ) { item in

                        MovieCard(
                            content: item
                        )
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}
