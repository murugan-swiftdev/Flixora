//
//  MockSportsData.swift
//  Flixora
//
//  Created by Murugan on 19/08/26.
//

import Foundation

enum MockSportsData {
    
    static let matches: [SportsContent] = [
        
        // MARK: - Live
        
        SportsContent(
            title: "India vs Australia",
            league: "International Cricket",
            sport: .cricket,
            teamOne: "India",
            teamTwo: "Australia",
            teamOneScore: "184/4",
            teamTwoScore: "142/7",
            startTime: "LIVE",
            language: "English",
            imageName: "sports_cricket_1",
            status: .live,
            isPremium: false
        ),
        
        SportsContent(
            title: "Real Madrid vs Barcelona",
            league: "La Liga",
            sport: .football,
            teamOne: "Real Madrid",
            teamTwo: "Barcelona",
            teamOneScore: "2",
            teamTwoScore: "1",
            startTime: "LIVE",
            language: "English",
            imageName: "sports_football_1",
            status: .live,
            isPremium: true
        ),
        
        // MARK: - Upcoming
        
        SportsContent(
            title: "India vs England",
            league: "ICC Champions Trophy",
            sport: .cricket,
            teamOne: "India",
            teamTwo: "England",
            teamOneScore: nil,
            teamTwoScore: nil,
            startTime: "Today • 7:30 PM",
            language: "Tamil",
            imageName: "sports_cricket_2",
            status: .upcoming,
            isPremium: false
        ),
        
        SportsContent(
            title: "Manchester City vs Liverpool",
            league: "Premier League",
            sport: .football,
            teamOne: "Manchester City",
            teamTwo: "Liverpool",
            teamOneScore: nil,
            teamTwoScore: nil,
            startTime: "Tomorrow • 9:00 PM",
            language: "English",
            imageName: "sports_football_2",
            status: .upcoming,
            isPremium: true
        ),
        
        SportsContent(
            title: "Chennai vs Mumbai",
            league: "Indian Basketball League",
            sport: .basketball,
            teamOne: "Chennai",
            teamTwo: "Mumbai",
            teamOneScore: nil,
            teamTwoScore: nil,
            startTime: "Tomorrow • 6:00 PM",
            language: "Tamil",
            imageName: "sports_basketball_1",
            status: .upcoming,
            isPremium: false
        ),
        
        SportsContent(
            title: "Formula 1 Grand Prix",
            league: "Formula 1",
            sport: .motorsport,
            teamOne: "Red Bull",
            teamTwo: "Ferrari",
            teamOneScore: nil,
            teamTwoScore: nil,
            startTime: "Sunday • 7:30 PM",
            language: "English",
            imageName: "sports_f1_1",
            status: .upcoming,
            isPremium: true
        ),
        
        // MARK: - Completed
        
        SportsContent(
            title: "India vs South Africa",
            league: "T20 International",
            sport: .cricket,
            teamOne: "India",
            teamTwo: "South Africa",
            teamOneScore: "178/6",
            teamTwoScore: "165/8",
            startTime: "Completed",
            language: "Hindi",
            imageName: "sports_cricket_3",
            status: .completed,
            isPremium: false
        )
    ]
}
