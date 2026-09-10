//
//  SearchView.swift
//  Flixora
//
//  Created by Murugan on 19/08/26.
//

import SwiftUI

struct SearchView: View {

    @State private var searchText = ""

    private var allContents: [OTTContent] {

        MockContentData.continueWatching
        + MockContentData.trending
        + MockContentData.popularMovies
        + MockContentData.popularSeries
        + MockContentData.sports
    }

    private var searchResults: [OTTContent] {

        // Delegate to the shared search helper. Keep the same behaviour of returning
        // no results when query is empty by early-exiting.
        guard !searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
        else { return [] }

        return searchContents(
            allContents,
            query: searchText,
            selectedLanguage: nil,
            selectedGenre: nil,
            deduplicate: true
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

                searchBar

                if searchText.isEmpty {

                    emptySearchState

                } else if searchResults.isEmpty {

                    noResultsView

                } else {

                    resultsSection
                }
            }
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.large)
        .background(Color(.systemBackground))
    }

    // MARK: - Search Bar

    private var searchBar: some View {

        HStack(spacing: 10) {

            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField(
                "Search movies, series, sports...",
                text: $searchText
            )
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()

            if !searchText.isEmpty {

                Button {

                    searchText = ""

                } label: {

                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(
            Color.gray.opacity(0.12)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 16
            )
        )
        .padding(.horizontal, 16)
    }

    // MARK: - Empty State

    private var emptySearchState: some View {

        VStack(spacing: 18) {

            Image(systemName: "film.stack")

                .font(
                    .system(
                        size: 55,
                        weight: .medium
                    )
                )
                .foregroundStyle(.red)

            Text("Find something to watch")

                .font(.title3.bold())

            Text(
                "Search for movies, series, sports and more."
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
        }
        .frame(
            maxWidth: .infinity
        )
        .padding(.top, 80)
        .padding(.horizontal, 30)
    }

    // MARK: - No Results

    private var noResultsView: some View {

        VStack(spacing: 16) {

            Image(systemName: "magnifyingglass")

                .font(
                    .system(
                        size: 48,
                        weight: .medium
                    )
                )
                .foregroundStyle(.secondary)

            Text("No results found")

                .font(.title3.bold())

            Text(
                "Try searching with a different movie, series or genre."
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
        }
        .frame(
            maxWidth: .infinity
        )
        .padding(.top, 70)
        .padding(.horizontal, 30)
    }

    // MARK: - Results

    private var resultsSection: some View {

        VStack(
            alignment: .leading,
            spacing: 14
        ) {

            Text(
                "\(searchResults.count) Results"
            )
            .font(.title3.bold())
            .padding(.horizontal, 16)

            LazyVStack(spacing: 12) {

                ForEach(searchResults) { content in

                    NavigationLink {

                        ContentDetailView(
                            content: content
                        )

                    } label: {

                        SearchResultRow(
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

struct SearchResultRow: View {

    let content: OTTContent

    var body: some View {

        HStack(spacing: 14) {

            Image(content.posterName)
                .resizable()
                .scaledToFill()
                .frame(
                    width: 95,
                    height: 125
                )
                .clipped()
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 12
                    )
                )

            VStack(
                alignment: .leading,
                spacing: 8
            ) {

                HStack(spacing: 6) {

                    Text(content.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(2)

                    if content.isPremium {

                        Image(systemName: "crown.fill")
                            .font(.caption)
                            .foregroundStyle(.yellow)
                    }
                }

                HStack(spacing: 6) {

                    Image(systemName: "star.fill")
                        .font(.caption2)
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

                Text(content.genre)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(content.language)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()
            }

            Spacer()

            Image(
                systemName: "chevron.right"
            )
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(
            Color.gray.opacity(0.08)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 16
            )
        )
    }
}
