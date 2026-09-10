//
//  SportsModels.swift
//  Flixora
//
//  Created by Murugan on 19/08/26.
//

import Foundation

enum SportType: String, CaseIterable, Identifiable {
    
    case all = "All"
    case cricket = "Cricket"
    case football = "Football"
    case basketball = "Basketball"
    case motorsport = "Motorsport"
    
    var id: String {
        rawValue
    }
    
    var icon: String {
        
        switch self {
        case .all:
            return "sportscourt.fill"
        case .cricket:
            return "figure.cricket"
        case .football:
            return "figure.soccer"
        case .basketball:
            return "basketball.fill"
        case .motorsport:
            return "car.fill"
        }
    }
}

enum MatchStatus: String {
    
    case live
    case upcoming
    case completed
}

struct SportsContent: Identifiable {
    
    let id = UUID()
    
    let title: String
    
    let league: String
    
    let sport: SportType
    
    let teamOne: String
    
    let teamTwo: String
    
    let teamOneScore: String?
    
    let teamTwoScore: String?
    
    let startTime: String
    
    let language: String
    
    let imageName: String
    
    let status: MatchStatus
    
    let isPremium: Bool
}
