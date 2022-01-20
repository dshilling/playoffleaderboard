//
//  LeagueLeaderboard.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/20/22.
//

import Foundation

class LeagueLeaderboard: ObservableObject {
    
    @Published var franchises = [LeaderboardFranchise]()
    
    // Construct an empty leaderboard to initialize UI
    init() {
        franchises = [LeaderboardFranchise]()
    }
    
    // Costruct the leaderboard from scoring data
    init(scoringObj: LeagueScoringObj) {
        
        // Put team names in a dictionary for lookup
        var teamDictionary: [String:String] = [:]
        for franchise in scoringObj.leagueDetails.franchises.franchise {
            teamDictionary[franchise.id] = franchise.name
        }
        
        // Put live scoring in a dictionary for lookup
        var liveScoringDictionary: [String:LiveScoringFranchise] = [:]
        for franchise in scoringObj.liveScoring.franchise {
            liveScoringDictionary[franchise.id] = franchise
        }
        
        // Initialize each team from the scoring data
        franchises = [LeaderboardFranchise]()
        for franchise in scoringObj.leagueStandings.franchise {
            var newTeam = LeaderboardFranchise()
            newTeam.id = franchise.id
            newTeam.name = teamDictionary[franchise.id] ?? ""
            newTeam.totalScore = Double(franchise.pf) ?? 0.0
            newTeam.totalScore += Date().timeIntervalSince1970
            newTeam.liveScoring = liveScoringDictionary[franchise.id] ?? LiveScoringFranchise()
            // Add live scoring totals if current live scoring week is after most recently completed week
            if (scoringObj.mflStatus.weeks.CompletedWeek != scoringObj.mflStatus.weeks.LiveScoringWeek) {
                let liveScores = liveScoringDictionary[franchise.id]
                newTeam.totalScore += Double(liveScores?.score ?? "0") ?? 0.0
            }
            franchises.append(newTeam)
        }
        
        // Sort the array in descending order by score
        franchises = franchises.sorted(by: { $0.totalScore > $1.totalScore } )
    }
    
}

struct LeaderboardFranchise: Hashable {
    var id: String
    var name: String
    var totalScore: Double
    var liveScoring: LiveScoringFranchise
    init() {
        id = ""
        name = ""
        totalScore = 0.0
        liveScoring = LiveScoringFranchise()
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id + name + String(format: "%.2f",totalScore))
    }
}
