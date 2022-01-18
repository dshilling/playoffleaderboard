//
//  League.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/17/22.
//

import Foundation

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
