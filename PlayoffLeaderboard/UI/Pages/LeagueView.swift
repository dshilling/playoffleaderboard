//
//  LeagueView.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/18/22.
//

import Foundation
import SwiftUI

struct LeagueView: View {
    
    // Active league for this page
    var activeLeague: League
    var scoringObj = LeagueScoringObj()
    
    // State variables
    @State private var isLoading: Bool = false
    @StateObject var leagueLeaderboard = LeagueLeaderboard()
    
    init(withLeague: League) {
        self.activeLeague = withLeague
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            List {
                Section {
                    if leagueLeaderboard.franchises.count > 0 {
                        ForEach(0 ..< leagueLeaderboard.franchises.count) { index in
                            let franchise = leagueLeaderboard.franchises[index]
                            let franchiseLabel = franchise.name + ", " + String(format: "%.2f", franchise.totalScore)
                            Label(franchiseLabel, systemImage: "\(index+1).circle.fill" )
                                .font(.title3)
                        }
                    }
                } header: {
                    Text("Leaderboard")
                }
            }
            .listStyle(.grouped)
            .foregroundColor(Color("AppNavy"))
            .disabled(isLoading)
            .blur(radius: isLoading ? 2 : 0)
            // Refresh action when pulling list
            .refreshable {
                self.leagueLeaderboard.franchises = [LeaderboardFranchise]()
                // Success completion
                let onSuccess = {
                    // scoringObj passed by reference and updated
                    //self.leagueLeaderboard.franchises = LeagueLeaderboard(scoringObj: self.scoringObj).franchises
                }
                // Error completion
                let onFailure = {}
                MflController.apiGetScoring(forLeague: self.activeLeague,
                                                   intoObject: self.scoringObj,
                                                   onSuccess: onSuccess,
                                                   onFailure: onFailure)
            }
            
            // Loading HUD
            if isLoading {
                LoadingDialogView()
            }
        }
        .navigationTitle(self.activeLeague.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            self.loadLeaderboard()
        }
    }
    
    func loadLeaderboard() {
        self.isLoading = true
        // Success completion
        let onSuccess = {
            // scoringObj passed by reference and updated
            self.leagueLeaderboard.franchises = LeagueLeaderboard(scoringObj: self.scoringObj).franchises
            self.isLoading = false
        }
        // Error completion
        let onFailure = {
            self.isLoading = false
        }
        MflController.apiGetScoring(forLeague: self.activeLeague,
                                           intoObject: self.scoringObj,
                                           onSuccess: onSuccess,
                                           onFailure: onFailure)
    }
    
}
