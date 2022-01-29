//
//  FantasyMatchup.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/23/22.
//

import Foundation

// The fantasy matchup for a certain player
struct FantasyMatchup {
    
    var minutesRemaining: Int
    var team: NflTeam
    var opponent: NflTeam
    
    init () {
        minutesRemaining = 0
        team = NflTeam()
        opponent = NflTeam()
    }
    
    init (fromMatchup: NflMatchup, forTeam: String) {
        self.init()
        self.minutesRemaining = (Int(fromMatchup.gameSecondsRemaining) ?? 0) / 60
        for team in fromMatchup.team {
            if (team.id == forTeam) {
                self.team = team
            } else {
                self.opponent = team
            }
        }
    }
    
    func formattedMatchup() -> String {
        if (opponent.id == "") {
            return "IDLE"
        } else {
            var str = self.team.id
            str += " " + self.team.score + "-" + self.opponent.score
            if (self.team.isHome == "1") {
                str += " VS "
            } else {
                str += " @ "
            }
            str += self.opponent.id
            if (self.minutesRemaining > 0) {
                str += " (" + String(self.minutesRemaining) + " mins)"
            } else {
                str += " (FINAL)"
            }
            return str
        }
    }
    
}
