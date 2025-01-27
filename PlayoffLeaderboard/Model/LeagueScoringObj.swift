//
//  LeagueScoringObj.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/20/22.
//

import Foundation

// Container for coalescing API responses needed to build a LeagueLeaderboard
class LeagueScoringObj {
    
    // MFL status containing current year and week data
    var mflStatus: MflStatus
    
    // Latest nfl schedule from NFL indexed by team id
    var nflSchedules: [String:FantasyMatchup]
    
    // Latest players array from MFL index by player id
    var mflPlayers: [String:Player]
        
    // Selected league details obj
    var leagueDetails: LeagueDetails
    
    // Standings of selected league after most recently completed week
    var leagueStandings: LeagueStandings
    
    // Live scoring for selected league in the current week
    var liveScoring: LiveScoring
    
    init() {
        mflStatus = MflStatus()
        nflSchedules = [:]
        mflPlayers = [:]
        leagueDetails = LeagueDetails()
        leagueStandings = LeagueStandings()
        liveScoring = LiveScoring()
    }
    
}
