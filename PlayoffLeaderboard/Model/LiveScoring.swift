//
//  LiveScoring.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/19/22.
//

import Foundation

// MFL API object
struct LiveScoringResponse: Codable {
    var liveScoring: LiveScoring
    init () {
        liveScoring = LiveScoring()
    }
}

struct LiveScoring: Codable {
    var week: String
    var franchise: [LiveScoringFranchise]
    init () {
        week = ""
        franchise = []
    }
}

struct LiveScoringFranchise: Codable, Hashable {
    var id: String                          // "0001"
    var score: String                       // "0.00"
    var playersCurrentlyPlaying: String     // "0"
    var playersYetToPlay: String            // "8"
    var gameSecondsRemaining: String        // "28800"
    var players: LiveScoringPlayers
    init() {
        id = ""
        score = ""
        playersCurrentlyPlaying = ""
        playersYetToPlay = ""
        gameSecondsRemaining = ""
        players = LiveScoringPlayers()
    }
    static func == (lhs: LiveScoringFranchise, rhs: LiveScoringFranchise) -> Bool {
        return lhs.id == rhs.id && lhs.score == rhs.score && lhs.gameSecondsRemaining == rhs.gameSecondsRemaining
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id+score+gameSecondsRemaining)
    }
}

struct LiveScoringPlayers: Codable {
    var player: [LiveScoringPlayer]
    
    init() {
        player = [LiveScoringPlayer]()
    }
    
    // Override Decoder method to handle cases where "league" is an object or a list
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.player = try values.decode([LiveScoringPlayer].self, forKey: .player)
        } catch {
            do {
                self.player = [LiveScoringPlayer]()
                let tempPlayer: LiveScoringPlayer = try values.decode(LiveScoringPlayer.self, forKey: .player)
                self.player.append(tempPlayer)
            } catch {
                print("No players found for franchise. Leave live scoring as empty list.")
            }
        }
    }
}

struct LiveScoringPlayer: Codable {
    
    var id: String                          // "0530"
    var score: String                       // "0.00"
    var status: String                      // "starter"
    var updatedStats: String                // ""
    var gameSecondsRemaining: String        // "3600"
    var name: String                        // From /players API, added later
    var position: String                    // From /players API, added later
    var team: String                        // From /players API, added later
    var matchup: String                     // From /nflSchedules API, added later
    
    init() {
        id = ""
        score = ""
        status = ""
        updatedStats = ""
        gameSecondsRemaining = ""
        name = ""
        position = ""
        team = ""
        matchup = ""
    }
    
    // Override Decoder method to supply 4 optional values
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(String.self, forKey: .id)
        self.score = try values.decode(String.self, forKey: .score)
        self.status = try values.decode(String.self, forKey: .status)
        self.updatedStats = try values.decode(String.self, forKey: .updatedStats)
        self.gameSecondsRemaining = try values.decode(String.self, forKey: .gameSecondsRemaining)
        name = ""     // added later
        position = "" // added later
        team = ""     // added later
        matchup = ""  // added later
    }
}
