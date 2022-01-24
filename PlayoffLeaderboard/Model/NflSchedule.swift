//
//  NflSchedule.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/23/22.
//

import Foundation

// MFL API object
struct NflScheduleResponse: Codable {
    var nflSchedule: NflSchedule
}

struct NflSchedule: Codable {
    var week: String
    var matchup: [NflMatchup]
    
    init () {
        week = ""
        matchup = [NflMatchup]()
    }
    
    // Override Decoder method to handle cases where "matchup" is an object or a list
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.week = try values.decode(String.self, forKey: .week)
        do {
            self.matchup = try values.decode([NflMatchup].self, forKey: .matchup)
        } catch {
            let tempMatchup: NflMatchup = try values.decode(NflMatchup.self, forKey: .matchup)
            self.matchup = [NflMatchup]()
            self.matchup.append(tempMatchup)
        }
    }
    
}

struct NflMatchup: Codable {
    var gameSecondsRemaining: String
    var status: String
    var team: [NflTeam]
    init () {
        gameSecondsRemaining = "0"
        status = ""
        team = [NflTeam]()
    }
}

struct NflTeam: Codable {
    var id: String
    var isHome: String
    var inRedZone: String
    var score: String
    var spread: String
    var hasPossession: String
    var passOffenseRank: String
    var rushOffenseRank: String
    var passDefenseRank: String
    var rushDefenseRank: String
    init () {
        id = ""
        isHome = ""
        inRedZone = ""
        score = ""
        spread = ""
        hasPossession = ""
        passOffenseRank = ""
        rushOffenseRank = ""
        passDefenseRank = ""
        rushDefenseRank = ""
    }
}
