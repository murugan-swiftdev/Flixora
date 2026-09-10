//
//  MoviesView.swift
//  Flixora
//
//  Created by Murugan on 18/08/26.
//

import SwiftUI

struct MoviesView: View {

    @State private var viewModel = MoviesViewModel()

    @State private var selectedMovie: OTTContent?
    @State private var showMovieDetails = false

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {

            LazyVStack(alignment: .leading, spacing: 22) {

                header

                searchBar

                if viewModel.isSearchEmpty {

                    languageFilter

                    genreFilter

                    featuredMovie

                    movieSection(
                        title: "Trending Movies",
                        movies: viewModel.trendingMovies
                    )

                    movieSection(
                        title: "New Releases",
                        movies: viewModel.newReleases
                    )

                    movieSection(
                        title: "Top Rated",
                        movies: viewModel.topRatedMovies
                    )

                    allMoviesSection

                } else {

                    searchResultsSection
                }

                // bottom spacing to avoid content behind tab/safe area
                EmptyView()
            }
            .padding(.top, 8)
            .padding(.horizontal, 16)
            .padding(.bottom, 100)
        }
        .background(Color(.systemBackground))
        .navigationDestination(isPresented: $showMovieDetails) {
            if let selectedMovie {
                MovieDetailsView(content: selectedMovie)
            }
        }
    }
}

// MARK: - Navigation

private extension MoviesView {

    func openMovie(_ movie: OTTContent) {

        selectedMovie = movie

        DispatchQueue.main.async {
            showMovieDetails = true
        }
    }
}

// MARK: - Header

private extension MoviesView {

    var header: some View {

        HStack(spacing: 14) {

            VStack(alignment: .leading, spacing: 4) {

                Text("Movies")
                    .font(
                        .system(
                            size: 30,
                            weight: .bold
                        )
                    )

                Text("Find something you'll love")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "film.stack.fill")
                .font(.system(size: 28))
                .foregroundStyle(.red)
                .frame(width: 48, height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.red.opacity(0.10))
                )
        }
    }
}

// MARK: - Search

private extension MoviesView {

    var searchBar: some View {

        HStack(spacing: 10) {

            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.secondary)

            TextField(
                "Search movies, genres, languages...",
                text: $viewModel.searchText
            )
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .submitLabel(.search)

            if !viewModel.searchText.isEmpty {

                Button {

                    viewModel.searchText = ""

                } label: {

                    Image(
                        systemName: "xmark.circle.fill"
                    )
                    .font(.system(size: 17))
                    .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .frame(height: 50)
        .background(
            Color.gray.opacity(0.10)
        )
        .overlay {

            RoundedRectangle(cornerRadius: 15)
                .stroke(
                    Color.gray.opacity(0.12),
                    lineWidth: 1
                )
        }
        .clipShape(
            RoundedRectangle(
                cornerRadius: 15
            )
        )
        
    }
}

// MARK: - Language Filter

private extension MoviesView {

    var languageFilter: some View {

        VStack(
            alignment: .leading,
            spacing: 10
        ) {

            filterTitle(
                title: "Languages",
                selectedValue: viewModel.selectedLanguage
            )

            ScrollView(
                .horizontal,
                showsIndicators: false
            ) {

                HStack(spacing: 8) {

                    ForEach(
                        viewModel.languages,
                        id: \.self
                    ) { language in

                        filterChip(
                            title: language,
                            isSelected:
                                viewModel.selectedLanguage == language
                        ) {

                            viewModel.selectedLanguage = language
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Genre Filter

private extension MoviesView {

    var genreFilter: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            filterTitle(
                title: "Genres",
                selectedValue: viewModel.selectedGenre
            )

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 10
            ) {

                ForEach(
                    viewModel.genres,
                    id: \.self
                ) { genre in

                    Button {

                        viewModel.selectedGenre = genre

                    } label: {

                        HStack(spacing: 5) {

                            if viewModel.selectedGenre == genre {

                                Image(
                                    systemName: "checkmark"
                                )
                                .font(
                                    .system(
                                        size: 9,
                                        weight: .bold
                                    )
                                )
                            }

                            Text(genre)
                                .font(
                                    .system(
                                        size: 12,
                                        weight: .semibold
                                    )
                                )
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)
                        }
                        .foregroundStyle(
                            viewModel.selectedGenre == genre
                            ? .white
                            : .primary
                        )
                        .frame(
                            maxWidth: .infinity
                        )
                        .frame(height: 38)
                        .background(
                            viewModel.selectedGenre == genre
                            ? Color.red
                            : Color.gray.opacity(0.10)
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 11
                            )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Filter Components

private extension MoviesView {

    func filterTitle(
        title: String,
        selectedValue: String
    ) -> some View {

        HStack {

            Text(title)
                .font(
                    .system(
                        size: 18,
                        weight: .bold
                    )
                )

            Spacer()

            Text(selectedValue)
                .font(
                    .system(
                        size: 12,
                        weight: .semibold
                    )
                )
                .foregroundStyle(.red)
        }
    }

    func filterChip(
        title: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {

        Button(action: action) {

            Text(title)
                .font(
                    .system(
                        size: 13,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    isSelected
                    ? .white
                    : .primary
                )
                .padding(.horizontal, 16)
                .frame(height: 38)
                .background(
                    isSelected
                    ? Color.red
                    : Color.gray.opacity(0.10)
                )
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Featured Movie

private extension MoviesView {

    var featuredMovie: some View {

        Group {

            if let movie = viewModel.trendingMovies.first {

                Button {

                    openMovie(movie)

                } label: {

                    ZStack(alignment: .bottomLeading) {

                        Image(movie.backdropName)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 250)
                            .clipped()

                        LinearGradient(
                            colors: [
                                .clear,
                                .black.opacity(0.92)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )

                        VStack(
                            alignment: .leading,
                            spacing: 8
                        ) {

                            Text("FEATURED")
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
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius: 6
                                    )
                                )

                            Text(movie.title)
                                .font(
                                    .system(
                                        size: 25,
                                        weight: .bold
                                    )
                                )
                                .foregroundStyle(.white)
                                .lineLimit(2)

                            HStack(spacing: 6) {

                                Text("\(movie.releaseYear)")

                                Text("•")

                                Text(movie.genre)

                                Text("•")

                                Text(
                                    String(
                                        format: "%.1f ⭐",
                                        movie.rating
                                    )
                                )
                            }
                            .font(.caption)
                            .foregroundStyle(
                                .white.opacity(0.85)
                            )
                        }
                        .padding(18)
                    }
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 18
                        )
                    )
                    .padding(.horizontal, 16)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - Movie Section

private extension MoviesView {
    
    private func movieSection(
        title: String,
        movies: [OTTContent]
    ) -> some View {

        Group {
            if movies.isEmpty {
                EmptyView()
            } else {
                VStack(alignment: .leading, spacing: 12) {

                    HStack {
                        Text(title)
                            .font(.title3.bold())

                        Spacer()

                        Text("\(movies.count)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 14) {
                            ForEach(movies) { movie in
                                MovieCard(content: movie)
                            }
                            }
                    }
                    .frame(height: 245)
                }
            }
        }
    }
}

// MARK: - Search Results

private extension MoviesView {

    var searchResultsSection: some View {

        VStack(
            alignment: .leading,
            spacing: 18
        ) {

            HStack {

                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {

                    Text("Search Results")
                        .font(
                            .system(
                                size: 21,
                                weight: .bold
                            )
                        )

                    Text(
                        "\(viewModel.filteredMovies.count) movies found"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }

                Spacer()
            }

            if viewModel.filteredMovies.isEmpty {

                emptySearchView

            } else {

                movieGrid(
                    movies: viewModel.filteredMovies
                )
            }
        }
    }
}

// MARK: - All Movies

private extension MoviesView {

    var allMoviesSection: some View {

        VStack(
            alignment: .leading,
            spacing: 16
        ) {

            HStack {

                Text("All Movies")
                    .font(
                        .system(
                            size: 21,
                            weight: .bold
                        )
                    )

                Spacer()

                Text(
                    "\(viewModel.filteredMovies.count) Movies"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            if viewModel.filteredMovies.isEmpty {

                emptyFilterView

            } else {

                movieGrid(
                    movies: viewModel.filteredMovies
                )
            }
        }
    }
}

// MARK: - Movie Grid

private extension MoviesView {

    func movieGrid(
        movies: [OTTContent]
    ) -> some View {

        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ],
            spacing: 20
        ) {

            ForEach(movies) { movie in

                Button {

                    openMovie(movie)

                } label: {

                    MovieCard(
                        content: movie
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
    }
    
    // Create a function that filters movies by title
    func filterMoviesByTitle(
        movies: [OTTContent],
        title: String
    ) -> [OTTContent] {
        
        let lowercasedTitle = title.lowercased()
        
        return movies.filter { movie in
            movie.title.lowercased().contains(lowercasedTitle)
        }
    }


}

// MARK: - Empty States

private extension MoviesView {

    var emptySearchView: some View {

        VStack(spacing: 12) {

            Image(systemName: "film.slash")
                .font(.system(size: 42))
                .foregroundStyle(.secondary)

            Text("No movies found")
                .font(
                    .system(
                        size: 18,
                        weight: .bold
                    )
                )

            Text(
                "Try a different movie title, genre or language."
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)

            Button {

                viewModel.searchText = ""

            } label: {

                Text("Clear Search")
                    .font(
                        .system(
                            size: 14,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.white)
                    .padding(
                        .horizontal,
                        18
                    )
                    .frame(height: 40)
                    .background(.red)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .padding(.top, 4)
        }
        .frame(
            maxWidth: .infinity
        )
        .padding(.vertical, 50)
        .padding(.horizontal, 30)
    }

    var emptyFilterView: some View {

        VStack(spacing: 10) {

            Image(systemName: "film.stack")
                .font(.system(size: 36))
                .foregroundStyle(.secondary)

            Text("No movies available")
                .font(
                    .system(
                        size: 17,
                        weight: .semibold
                    )
                )

            Text("Try changing your filters.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(
            maxWidth: .infinity
        )
        .padding(.vertical, 40)
    }
}

