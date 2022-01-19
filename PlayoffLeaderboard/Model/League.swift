//
//  League.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/17/22.
//

import Foundation

// Observable class for managing application state
class MyLeagues: ObservableObject {
    
    // All leagues for this user
    var leagues: Leagues
    
    var league: League?
    
    init() {
        leagues = Leagues()
        league = nil
    }
    
}

// MFL API object
struct League: Codable {
    var franchiseId: String
    var url: String
    var name: String
    var franchiseName: String
    var leagueId: String
}
typealias Leagues = [League]

// MFL API object
struct LeagueObj: Codable {
    var league: Leagues
}

// MFL API object
struct LeaguesObj: Codable {
    var leagues: LeagueObj
}
