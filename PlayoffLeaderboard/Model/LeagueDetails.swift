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
    
    init() {}
    
}

// MFL API object
struct LeagueDetailsResponse: Codable {
    var league: LeagueDetails
}

struct LeagueDetails: Codable {
    var id: String
    var name: String
    var baseURL: String
    var franchise: [Franchise]
}

struct Franchise: Codable {
    var id: String
    var name: String
}
