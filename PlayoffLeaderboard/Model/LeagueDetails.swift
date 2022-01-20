//
//  LeagueDetails.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/19/22.
//

import Foundation

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
