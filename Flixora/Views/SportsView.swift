//
//  SportsView.swift
//  Flixora
//
//  Created by Murugan on 19/08/26.
//

import SwiftUI

struct SportsView: View {
    
    @State private var viewModel =
        SportsViewModel()
    
    @State private var selectedMatch:
        SportsContent?
    
    @State private var showMatchDetails =
        false
    
    var body: some View {
        
        ScrollView(
            .vertical,
            showsIndicators: false
        ) {
            
            VStack(
                alignment: .leading,
                spacing: 24
            ) {
                
                header
                
                searchBar
                
                sportFilter
                
                languageFilter
                
                liveSection
                
                upcomingSection
                
                completedSection
                
                Spacer()
                    .frame(height: 100)
            }
            .padding(.top, 8)
        }
        .background(
            Color(.systemBackground)
        )
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(
            isPresented:
                $showMatchDetails
        ) {
            
            if let selectedMatch {
                
                MatchDetailsView(
                    content: selectedMatch
                )
            }
        }
    }
}

private extension SportsView {
    
    var header: some View {
        
        HStack {
            
            VStack(
                alignment: .leading,
                spacing: 3
            ) {
                
                Text("Sports")
                    .font(
                        .system(
                            size: 30,
                            weight: .bold
                        )
                    )
                
                Text(
                    "Live matches, scores & upcoming events"
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(
                systemName:
                    "sportscourt.fill"
            )
            .font(.system(size: 30))
            .foregroundStyle(.red)
        }
        .padding(.horizontal, 16)
    }
}

private extension SportsView {
    
    var searchBar: some View {
        
        HStack(spacing: 10) {
            
            Image(
                systemName:
                    "magnifyingglass"
            )
            .foregroundStyle(.secondary)
            
            TextField(
                "Search matches...",
                text: $viewModel.searchText
            )
            
            if !viewModel.searchText.isEmpty {
                
                Button {
                    
                    viewModel.searchText = ""
                    
                } label: {
                    
                    Image(
                        systemName:
                            "xmark.circle.fill"
                    )
                    .foregroundStyle(.secondary)
                }
            }
        }
        .padding(13)
        .background(
            .gray.opacity(0.12)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 14
            )
        )
        .padding(.horizontal, 16)
    }
}

private extension SportsView {
    
    var sportFilter: some View {
        
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            
            Text("Sports")
                .font(.headline)
                .padding(.horizontal, 16)
            
            ScrollView(
                .horizontal,
                showsIndicators: false
            ) {
                
                HStack(spacing: 10) {
                    
                    ForEach(
                        SportType.allCases
                    ) { sport in
                        
                        Button {
                            
                            viewModel.selectedSport =
                                sport
                            
                        } label: {
                            
                            HStack(spacing: 6) {
                                
                                Image(
                                    systemName:
                                        sport.icon
                                )
                                
                                Text(sport.rawValue)
                            }
                            .font(
                                .system(
                                    size: 13,
                                    weight: .semibold
                                )
                            )
                            .foregroundStyle(
                                viewModel.selectedSport == sport
                                ? .white
                                : .primary
                            )
                            .padding(
                                .horizontal,
                                14
                            )
                            .padding(
                                .vertical,
                                10
                            )
                            .background(
                                Capsule()
                                    .fill(
                                        viewModel.selectedSport == sport
                                        ? Color.red
                                        : Color.gray.opacity(0.12)
                                    )
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

private extension SportsView {
    
    var languageFilter: some View {
        
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            
            Text("Languages")
                .font(.headline)
                .padding(.horizontal, 16)
            
            ScrollView(
                .horizontal,
                showsIndicators: false
            ) {
                
                HStack(spacing: 10) {
                    
                    ForEach(
                        viewModel.languages,
                        id: \.self
                    ) { language in
                        
                        Button {
                            
                            viewModel.selectedLanguage =
                                language
                            
                        } label: {
                            
                            Text(language)
                                .font(
                                    .system(
                                        size: 13,
                                        weight: .semibold
                                    )
                                )
                                .foregroundStyle(
                                    viewModel.selectedLanguage == language
                                    ? .white
                                    : .primary
                                )
                                .padding(
                                    .horizontal,
                                    15
                                )
                                .padding(
                                    .vertical,
                                    9
                                )
                                .background(
                                    Capsule()
                                        .fill(
                                            viewModel.selectedLanguage == language
                                            ? Color.red
                                            : Color.gray.opacity(0.12)
                                        )
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

private extension SportsView {
    
    var upcomingSection: some View {
        
        sportsSection(
            title: "Upcoming",
            matches: viewModel.upcomingMatches
        )
    }
}

private extension SportsView {
    
    var completedSection: some View {
        
        sportsSection(
            title: "Recent Results",
            matches: viewModel.completedMatches
        )
    }
}

private extension SportsView {
    
    func sportsSection(
        title: String,
        matches: [SportsContent]
    ) -> some View {
        
        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            
            HStack {
                
                Text(title)
                    .font(
                        .title3
                    )
                    .fontWeight(.bold)
                
                Spacer()
                
                Text(
                    "\(matches.count)"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            
            if matches.isEmpty {
                
                Text("No matches available")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 16)
                
            } else {
                
                ScrollView(
                    .horizontal,
                    showsIndicators: false
                ) {
                    
                    HStack(spacing: 14) {
                        
                        ForEach(matches) { match in
                            
                            Button {
                                
                                selectedMatch =
                                    match
                                
                                showMatchDetails =
                                    true
                                
                            } label: {
                                
                                SportsCard(
                                    content: match
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .frame(height: 270)
            }
        }
    }
}

private extension SportsView {
    
    var liveSection: some View {
        
        sportsSection(
            title: "🔴 Live Now",
            matches: viewModel.liveMatches
        )
    }
}
