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
    @Published var leagues: Leagues
        
    init() {
        leagues = Leagues()
    }
    
}

// MFL API object
struct LeaguesObj: Codable {
    var leagues: Leagues
    init() {
        leagues = Leagues()
    }
}

struct Leagues: Codable {
    var league: [League]
    init() {
        league = [League]()
    }
}

struct League: Codable {
    var franchiseId: String
    var url: String
    var name: String
    var franchiseName: String
    var leagueId: String
    init() {
        franchiseId = ""
        url = ""
        name = ""
        franchiseName = ""
        leagueId = ""
    }
}
