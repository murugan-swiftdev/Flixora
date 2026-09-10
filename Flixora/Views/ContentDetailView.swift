//
//  ContentDetailView.swift
//  Flixora
//
//  Created by Murugan on 18/08/26.
//

import SwiftUI
import SwiftData

struct ContentDetailView: View {

    let content: OTTContent

    @Environment(\.dismiss)
    private var dismiss

    @Environment(MyListManager.self)
    private var myListManager

    @Environment(\.modelContext)
    private var modelContext

    @State private var showPlayer = false
    @State private var showSubscription = false

    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()

            ScrollView(
                .vertical,
                showsIndicators: false
            ) {

                VStack(
                    alignment: .leading,
                    spacing: 22
                ) {

                    // MARK: - Backdrop

                    ZStack(alignment: .bottomLeading) {

                        Image(content.backdropName)
                            .resizable()
                            .scaledToFill()
                            .frame(
                                maxWidth: .infinity,
                                minHeight: 320,
                                maxHeight: 320
                            )
                            .clipped()

                        LinearGradient(
                            colors: [
                                .clear,
                                .black.opacity(0.25),
                                .black
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )

                        VStack(
                            alignment: .leading,
                            spacing: 8
                        ) {

                            if content.isPremium {

                                HStack(spacing: 5) {

                                    Image(
                                        systemName: "crown.fill"
                                    )

                                    Text("PREMIUM")
                                        .fontWeight(.bold)
                                }
                                .font(.caption2)
                                .foregroundStyle(.black)
                                .padding(.horizontal, 9)
                                .padding(.vertical, 6)
                                .background(.yellow)
                                .clipShape(Capsule())
                            }

                            Text(content.title)
                                .font(
                                    .system(
                                        size: 32,
                                        weight: .bold
                                    )
                                )
                                .foregroundStyle(.white)
                        }
                        .padding(20)
                    }

                    // MARK: - Content Information

                    VStack(
                        alignment: .leading,
                        spacing: 18
                    ) {

                        // MARK: Metadata

                        HStack(spacing: 9) {

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

                            Text("•")

                            Text(content.genre)

                            Text("•")

                            Text(
                                "\(content.duration) min"
                            )
                        }
                        .font(.subheadline)
                        .foregroundStyle(
                            .white.opacity(0.75)
                        )

                        // MARK: Language

                        HStack(spacing: 6) {

                            Image(
                                systemName: "globe"
                            )

                            Text(content.language)
                        }
                        .font(.subheadline)
                        .foregroundStyle(
                            .white.opacity(0.7)
                        )

                        // MARK: Description

                        Text(content.description)
                            .font(.body)
                            .foregroundStyle(
                                .white.opacity(0.85)
                            )
                            .lineSpacing(5)

                        // MARK: Buttons

                        HStack(spacing: 12) {

                            // MARK: Watch Now

                            Button {

                                print(
                                    "WATCH NOW TAPPED: \(content.title)"
                                )

                                if content.isPremium {

                                    print(
                                        "PREMIUM CONTENT"
                                    )

                                    showSubscription = true

                                } else {

                                    print(
                                        "FREE CONTENT"
                                    )

                                    showPlayer = true
                                }

                            } label: {

                                HStack(spacing: 8) {

                                    Image(
                                        systemName: "play.fill"
                                    )

                                    Text("Watch Now")
                                }
                                .font(.headline)
                                .foregroundStyle(.black)
                                .frame(
                                    maxWidth: .infinity
                                )
                                .padding(.vertical, 15)
                                .background(.white)
                                .clipShape(Capsule())
                            }

                            // MARK: My List

                            Button {

                                myListManager.toggle(content)

                            } label: {

                                Image(
                                    systemName:
                                        myListManager.contains(content)
                                        ? "checkmark"
                                        : "plus"
                                )
                                .font(.title2.bold())
                                .foregroundStyle(.white)
                                .frame(
                                    width: 52,
                                    height: 52
                                )
                                .background(
                                    Color.white.opacity(0.12)
                                )
                                .clipShape(Circle())
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }

        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)

        .toolbar {

            ToolbarItem(
                placement: .topBarTrailing
            ) {

                Button {

                    dismiss()

                } label: {

                    Image(
                        systemName: "xmark"
                    )
                    .foregroundStyle(.white)
                }
            }
        }

        // MARK: - Video Player

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

        // MARK: - Subscription

        .fullScreenCover(
            isPresented: $showSubscription
        ) {

            SubscriptionView()
        }

        .preferredColorScheme(.dark)

        // MARK: - Configure My List

        .task {

            myListManager.configure(
                context: modelContext
            )
        }
    }
}
