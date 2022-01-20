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
    init() {
        league = LeagueDetails()
    }
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
