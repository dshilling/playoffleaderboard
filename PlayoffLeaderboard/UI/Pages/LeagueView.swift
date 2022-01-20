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
    
    // State variables
    @State private var isLoading: Bool = false
    @StateObject var scoringObj = LeagueScoringObj()
    
    init(withLeague: League) {
        self.activeLeague = withLeague
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack {
                // TODO: Complete This Section
                /*
                Text("Year:" + scoringObj.mflStatus.year)
                Text("Live Week:" + scoringObj.mflStatus.weeks.LiveScoringWeek)
                Text("Completed Week:" + scoringObj.mflStatus.weeks.CompletedWeek)
                */
                Text("Teams:")
                ForEach(scoringObj.leagueDetails.franchises.franchise, id:\.self) {franchise in
                    Text(franchise.id + ", " + franchise.name)
                }
                Text("Scores:").padding(.top, 20)
                ForEach(scoringObj.leagueStandings.franchise, id:\.self) {franchise in
                    Text(franchise.id + ", " + franchise.pf)
                }
                Text("Live Scores:").padding(.top, 20)
                ForEach(scoringObj.liveScoring.franchise, id:\.self) {franchise in
                    Text(franchise.id + ", " + franchise.score + ", " + franchise.gameSecondsRemaining)
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
