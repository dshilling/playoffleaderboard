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
            newTeam.liveScoring = liveScoringDictionary[franchise.id] ?? LiveScoringFranchise()
            // Add in live scoring totals only if current live scoring week is after most recently completed week
            if (scoringObj.mflStatus.weeks.CompletedWeek != scoringObj.mflStatus.weeks.LiveScoringWeek) {
                newTeam.totalScore += Double(newTeam.liveScoring.score) ?? 0.0
            }
            
            // Also fill in player data optional fields
            if newTeam.liveScoring.players.player.count > 0 {
                for index in 0...newTeam.liveScoring.players.player.count-1 {
                    let playerData = scoringObj.mflPlayers[newTeam.liveScoring.players.player[index].id] ?? Player()
                    newTeam.liveScoring.players.player[index].name = playerData.name
                    newTeam.liveScoring.players.player[index].team = playerData.team
                    newTeam.liveScoring.players.player[index].position = playerData.position
                    newTeam.liveScoring.players.player[index].matchup =
                        (scoringObj.nflSchedules[newTeam.liveScoring.players.player[index].team] ?? FantasyMatchup()).formattedMatchup()
                }
            }
            
            // Count all players in first week (byes). Otherwise count players in matchups.
            newTeam.playersRemaining = 0
            for player in newTeam.liveScoring.players.player {
                if ((scoringObj.mflStatus.weeks.CurrentWeek == "19") || player.matchup != "IDLE") {
                    newTeam.playersRemaining += 1
                }
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
    var playersRemaining: Int
    init() {
        id = ""
        name = ""
        totalScore = 0.0
        liveScoring = LiveScoringFranchise()
        playersRemaining = 0
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id + name + String(format: "%.2f",totalScore))
    }
}
