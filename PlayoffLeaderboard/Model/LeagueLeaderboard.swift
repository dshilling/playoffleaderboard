//
//  LeagueLeaderboard.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/20/22.
//

import Foundation

// Observable class for managing application state
class LeagueLeaderboard: ObservableObject {
    
    // MFL status containing current year and week data
    var mflStatus: MflStatus
    
    // Selected league details obj
    var leagueDetails: LeagueDetails
    
    // Standings of selected league after most recently completed week
    var leagueStandings: LeagueStandings
    
    // Live scoring for selected league in the current week
    var liveScoring: LiveScoring
    
    init() {
        mflStatus = MflStatus()
        leagueDetails = LeagueDetails()
        leagueStandings = LeagueStandings()
        liveScoring = LiveScoring()
    }
    
}
