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
            VStack {
                // TODO: Complete This Section
                Text("Leaderboard:")
                ForEach(leagueLeaderboard.franchises, id:\.self) {franchise in
                    Text(franchise.name + ", " + String(format: "%.2f", franchise.totalScore))
                }
            }
            .foregroundColor(Color("AppNavy"))
            .padding()
            .disabled(isLoading)
            .blur(radius: isLoading ? 2 : 0)
            
            // Loading HUD
            if isLoading {
                LoadingDialogView()
            }
        }
        .navigationTitle(self.activeLeague.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
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
    
}
