//
//  LeagueDetails.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/19/22.
//

import Foundation

// Observable class for managing application state
class LeagueLeaderboard: ObservableObject {
    
    // Selected league details obj
    var leagueDetails: LeagueDetails?
    
    // Standings of selected league after most recently completed week
    var leagueStandings: LeagueStandings?
    
    // Live scoring for selected league in the current week
    var liveScoring: LiveScoring?
    
    init() {
        leagueDetails = LeagueDetails()
        leagueStandings = LeagueStandings()
        liveScoring = LiveScoring()
    }
    
}

// MFL API object
struct LeagueDetailsResponse: Codable {
    var league: LeagueDetails
}

struct LeagueDetails: Codable {
    var id: String
    var name: String
    var baseURL: String
    var franchises: Franchises
    init () {
        id = ""
        name = ""
        baseURL = ""
        franchises = Franchises()
    }
}

struct Franchises: Codable {
    var franchise: [Franchise]
    init() {
        franchise = [Franchise]()
    }
}

struct Franchise: Codable, Hashable {
    var id: String
    var name: String
    func hash(into hasher: inout Hasher) {
        hasher.combine(id+name)
    }
}
