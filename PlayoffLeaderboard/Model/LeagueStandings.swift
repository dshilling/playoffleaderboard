//
//  LeagueStandings.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/19/22.
//

import Foundation

// MFL API object
struct LeagueStandingsResponse: Codable {
    var leagueStandings: LeagueStandings
    init () {
        leagueStandings = LeagueStandings()
    }
}

struct LeagueStandings: Codable {
    var franchise: [LeagueStandingsFranchise]
    init () {
        franchise = [LeagueStandingsFranchise]()
    }
}

struct LeagueStandingsFranchise: Codable, Hashable {
    var id: String
    var pf: String
    func hash(into hasher: inout Hasher) {
        hasher.combine(id+pf)
    }
}
