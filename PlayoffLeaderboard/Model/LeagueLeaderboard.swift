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
                    if playerData.position.uppercased() == "DEF" {
                        // DEF - too long for display
                        newTeam.liveScoring.players.player[index].position = "D"
                    } else {
                        newTeam.liveScoring.players.player[index].position = playerData.position
                    }
                    newTeam.liveScoring.players.player[index].matchup =
                        (scoringObj.nflSchedules[newTeam.liveScoring.players.player[index].team] ?? FantasyMatchup()).formattedMatchup()
                }
            }
            
            // Sort live scoring players by position
            var sortedList = [LiveScoringPlayer]()
            for p in newTeam.liveScoring.players.player {
                if (p.position.caseInsensitiveCompare("QB") == .orderedSame) { sortedList.append(p) }
            }
            for p in newTeam.liveScoring.players.player {
                if (p.position.caseInsensitiveCompare("RB") == .orderedSame) { sortedList.append(p) }
            }
            for p in newTeam.liveScoring.players.player {
                if (p.position.caseInsensitiveCompare("WR") == .orderedSame) { sortedList.append(p) }
            }
            for p in newTeam.liveScoring.players.player {
                if (p.position.caseInsensitiveCompare("TE") == .orderedSame) { sortedList.append(p) }
            }
            for p in newTeam.liveScoring.players.player {
                if (p.position.caseInsensitiveCompare("DEF") == .orderedSame) {
                    sortedList.append(p) }
            }
            for p in newTeam.liveScoring.players.player {
                if (p.position.caseInsensitiveCompare("D") == .orderedSame) {
                    sortedList.append(p) }
            }
            for p in newTeam.liveScoring.players.player {
                if (p.position.caseInsensitiveCompare("PK") == .orderedSame) { sortedList.append(p) }
            }
            for p in newTeam.liveScoring.players.player {
                if (p.position.caseInsensitiveCompare("QB")  != .orderedSame &&
                    p.position.caseInsensitiveCompare("RB")  != .orderedSame &&
                    p.position.caseInsensitiveCompare("WR")  != .orderedSame &&
                    p.position.caseInsensitiveCompare("TE")  != .orderedSame &&
                    p.position.caseInsensitiveCompare("DEF") != .orderedSame &&
                    p.position.caseInsensitiveCompare("D") != .orderedSame &&
                    p.position.caseInsensitiveCompare("PK")  != .orderedSame) {
                    sortedList.append(p)
                }
            }
            newTeam.liveScoring.players.player = sortedList
            
            // Count all players in first week (byes). Otherwise count players in matchups.
            newTeam.playersRemaining = 0
            for player in newTeam.liveScoring.players.player {
                if ((scoringObj.mflStatus.weeks.CurrentWeek == "19") || player.matchup != "IDLE") {
                    newTeam.playersRemaining += 1
                }
            }
            
            franchises.append(newTeam)
        }
        
        // First, sort by live scoring to set the weekly leader flag
        if (franchises.count > 1) {
            franchises = franchises.sorted(by: { Double($0.liveScoring.score) ?? 0 > Double($1.liveScoring.score) ?? 0} )
            if (Double(franchises[0].liveScoring.score) ?? 0 > 0) {
                for i in 0 ..< franchises.count {
                    if (franchises[i].liveScoring.score == franchises[0].liveScoring.score) {
                        franchises[i].isWeeklyTopscore = true
                    }
                }
            }
        }
        
        // Resort the array in descending order by total score for display
        franchises = franchises.sorted(by: { $0.totalScore > $1.totalScore } )
    }
    
}

struct LeaderboardFranchise: Hashable {
    var id: String
    var name: String
    var totalScore: Double
    var liveScoring: LiveScoringFranchise
    var playersRemaining: Int
    var isWeeklyTopscore: Bool // Indicates top scoring team for current week
    init() {
        id = ""
        name = ""
        totalScore = 0.0
        liveScoring = LiveScoringFranchise()
        playersRemaining = 0
        isWeeklyTopscore = false
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id + name + String(format: "%.2f",totalScore))
    }
}
