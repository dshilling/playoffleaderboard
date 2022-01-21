//
//  Players.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/20/22.
//

import Foundation

// MFL API object
struct PlayersResponse: Codable {
    var players: Players
    init() {
        players = Players()
    }
}

struct Players: Codable {
    var player: [Player]
    init() {
        player = [Player]()
    }
}

struct Player: Codable {
    var id: String
    var name: String
    var position: String
    var team: String
    init() {
        id = ""
        name = ""
        position = ""
        team = ""
    }
}
