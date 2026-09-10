//
//  MatchDetailsView.swift
//  Flixora
//
//  Created by Murugan on 19/08/26.
//

import SwiftUI

struct MatchDetailsView: View {

    @State private var viewModel: MatchDetailsViewModel

    @Environment(\.dismiss)
    private var dismiss

    init(content: SportsContent) {

        _viewModel = State(
            initialValue:
                MatchDetailsViewModel(
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

                matchInfo

                actionButtons

                scoreSection

                aboutSection

                commentarySection

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
                        .black.opacity(0.55)
                    )
                    .clipShape(Circle())
                }
            }
        }
        .fullScreenCover(
            isPresented:
                $viewModel.showSubscription
        ) {

            SubscriptionView()
        }
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

private extension MatchDetailsView {

    var heroSection: some View {

        ZStack(
            alignment: .bottomLeading
        ) {

            Image(
                viewModel.content.imageName
            )
            .resizable()
            .scaledToFill()
            .frame(
                maxWidth: .infinity
            )
            .frame(height: 360)
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

                HStack(spacing: 8) {

                    if viewModel.content.status == .live {

                        HStack(spacing: 5) {

                            Circle()
                                .fill(.red)
                                .frame(
                                    width: 7,
                                    height: 7
                                )

                            Text("LIVE")
                        }
                        .font(
                            .system(
                                size: 10,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.white)
                        .padding(
                            .horizontal,
                            9
                        )
                        .padding(
                            .vertical,
                            5
                        )
                        .background(.red)
                        .clipShape(Capsule())
                    }

                    Text(
                        viewModel.content.league
                    )
                    .font(.caption)
                    .foregroundStyle(
                        .white.opacity(0.85)
                    )
                }

                Text(
                    viewModel.content.title
                )
                .font(
                    .system(
                        size: 30,
                        weight: .black
                    )
                )
                .foregroundStyle(.white)

                Text(
                    viewModel.content.startTime
                )
                .font(.subheadline)
                .foregroundStyle(
                    .white.opacity(0.8)
                )
            }
            .padding(20)
        }
        .frame(height: 360)
    }
}

private extension MatchDetailsView {

    var matchInfo: some View {

        HStack(
            alignment: .top,
            spacing: 20
        ) {

            infoItem(
                icon: "sportscourt.fill",
                title: "Sport",
                value:
                    viewModel.content.sport.rawValue
            )

            infoItem(
                icon: "globe",
                title: "Language",
                value:
                    viewModel.content.language
            )

            infoItem(
                icon: "calendar",
                title: "Status",
                value:
                    viewModel.content.status
                        .rawValue
                        .capitalized
            )
        }
        .frame(
            maxWidth: .infinity
        )
        .padding(.horizontal, 16)
    }

    func infoItem(
        icon: String,
        title: String,
        value: String
    ) -> some View {

        VStack(spacing: 7) {

            Image(systemName: icon)
                .font(
                    .system(
                        size: 18,
                        weight: .semibold
                    )
                )
                .foregroundStyle(.red)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(
                    .system(
                        size: 13,
                        weight: .semibold
                    )
                )
                .multilineTextAlignment(.center)
        }
        .frame(
            maxWidth: .infinity
        )
    }
}

private extension MatchDetailsView {

    var actionButtons: some View {

        HStack(spacing: 12) {

            Button {

                viewModel.watchNow()

            } label: {

                Label(
                    viewModel.content.status == .live
                    ? "Watch Live"
                    : "Watch",
                    systemImage:
                        "play.fill"
                )
                .fontWeight(.bold)
                .frame(
                    maxWidth: .infinity
                )
            }
            .buttonStyle(
                .borderedProminent
            )
            .tint(.red)

            Button {

                viewModel.toggleMyList()

            } label: {

                Image(
                    systemName:
                        viewModel.isInMyList
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

private extension MatchDetailsView {

    var scoreSection: some View {

        VStack(
            alignment: .leading,
            spacing: 16
        ) {

            Text("Match Score")
                .font(.title3)
                .fontWeight(.bold)

            HStack {

                teamScore(
                    name:
                        viewModel.content.teamOne,
                    score:
                        viewModel.content.teamOneScore
                )

                VStack(spacing: 5) {

                    Text("VS")
                        .font(
                            .system(
                                size: 13,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(
                            .secondary
                        )

                    if viewModel.content.status == .live {

                        Text("LIVE")
                            .font(
                                .system(
                                    size: 9,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(.red)
                    }
                }

                teamScore(
                    name:
                        viewModel.content.teamTwo,
                    score:
                        viewModel.content.teamTwoScore
                )
            }
            .padding(20)
            .frame(
                maxWidth: .infinity
            )
            .background(
                .gray.opacity(0.10)
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 18
                )
            )
        }
        .padding(.horizontal, 16)
    }

    func teamScore(
        name: String,
        score: String?
    ) -> some View {

        VStack(spacing: 8) {

            Image(
                systemName:
                    "shield.fill"
            )
            .font(.system(size: 30))
            .foregroundStyle(.red)

            Text(name)
                .font(
                    .system(
                        size: 14,
                        weight: .semibold
                    )
                )
                .multilineTextAlignment(
                    .center
                )

            if let score {

                Text(score)
                    .font(
                        .system(
                            size: 20,
                            weight: .bold
                        )
                    )
            } else {

                Text("-")
                    .font(
                        .system(
                            size: 20,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(
                        .secondary
                    )
            }
        }
        .frame(
            maxWidth: .infinity
        )
    }
}

private extension MatchDetailsView {

    var aboutSection: some View {

        VStack(
            alignment: .leading,
            spacing: 10
        ) {

            Text("About This Match")
                .font(.title3)
                .fontWeight(.bold)

            Text(
                "\(viewModel.content.teamOne) vs "
                + "\(viewModel.content.teamTwo) — "
                + "\(viewModel.content.league). "
                + "Watch the complete match live "
                + "on Flixora with multiple language "
                + "options."
            )
            .font(.body)
            .foregroundStyle(
                .secondary
            )
            .fixedSize(
                horizontal: false,
                vertical: true
            )
        }
        .padding(.horizontal, 16)
    }
}

private extension MatchDetailsView {

    var commentarySection: some View {

        VStack(
            alignment: .leading,
            spacing: 14
        ) {

            HStack {

                Text("Live Commentary")
                    .font(.title3)
                    .fontWeight(.bold)

                Spacer()

                Image(
                    systemName:
                        "mic.fill"
                )
                .foregroundStyle(.red)
            }

            commentaryRow(
                time: "78'",
                text:
                    "\(viewModel.content.teamOne) "
                    + "creates a great chance!"
            )

            commentaryRow(
                time: "75'",
                text:
                    "What a fantastic moment "
                    + "for the fans."
            )

            commentaryRow(
                time: "72'",
                text:
                    "The match continues with "
                    + "high intensity."
            )
        }
        .padding(.horizontal, 16)
    }

    func commentaryRow(
        time: String,
        text: String
    ) -> some View {

        HStack(
            alignment: .top,
            spacing: 12
        ) {

            Text(time)
                .font(
                    .system(
                        size: 12,
                        weight: .bold
                    )
                )
                .foregroundStyle(.red)
                .frame(width: 35)

            Text(text)
                .font(.subheadline)
                .foregroundStyle(
                    .secondary
                )
        }
    }
}

private extension MatchDetailsView {

    var relatedSection: some View {

        VStack(
            alignment: .leading,
            spacing: 14
        ) {

            Text("More Sports")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal, 16)

            ScrollView(
                .horizontal,
                showsIndicators: false
            ) {

                HStack(spacing: 14) {

                    ForEach(
                        MockSportsData.matches
                    ) { match in

                        if match.id !=
                            viewModel.content.id {

                            SportsCard(
                                content: match
                            )
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .frame(height: 270)
        }
    }
}
