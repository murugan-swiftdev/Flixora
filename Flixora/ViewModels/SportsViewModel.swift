//
//  SportsViewModel.swift
//  Flixora
//
//  Created by Murugan on 19/08/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class SportsViewModel {
    
    var selectedSport: SportType = .all
    
    var selectedLanguage = "All"
    
    var searchText = ""
    
    let languages = [
        "All",
        "Tamil",
        "Hindi",
        "English"
    ]
    
    private(set) var matches: [SportsContent] = []
    
    init() {
        loadSports()
    }
    
    func loadSports() {
        matches = MockSportsData.matches
    }
    
    // MARK: - Filtered Matches
    
    var filteredMatches: [SportsContent] {
        
        matches.filter { match in
            
            let sportMatches =
                selectedSport == .all ||
                match.sport == selectedSport
            
            let languageMatches =
                selectedLanguage == "All" ||
                match.language == selectedLanguage
            
            let searchMatches =
                searchText.isEmpty ||
                match.title.localizedCaseInsensitiveContains(
                    searchText
                )
            
            return
                sportMatches &&
                languageMatches &&
                searchMatches
        }
    }
    
    // MARK: - Live
    
    var liveMatches: [SportsContent] {
        
        filteredMatches.filter {
            $0.status == .live
        }
    }
    
    // MARK: - Upcoming
    
    var upcomingMatches: [SportsContent] {
        
        filteredMatches.filter {
            $0.status == .upcoming
        }
    }
    
    // MARK: - Completed
    
    var completedMatches: [SportsContent] {
        
        filteredMatches.filter {
            $0.status == .completed
        }
    }
}
