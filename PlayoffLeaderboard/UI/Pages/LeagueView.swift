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
            GeometryReader { geometry in
            VStack {
            List {
                Section {
                    if leagueLeaderboard.franchises.count > 0 {
                        ForEach(0 ..< leagueLeaderboard.franchises.count) { index in
                            FranchiseTableCell(rank:index, franchise: leagueLeaderboard.franchises[index])
                        }
                    }
                    else
                    {
                        Text("") // Placeholder
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
                self.refreshLeaderboard()
            }
            }
            .padding(.top, 5)
            .background(Color(UIColor.secondarySystemBackground))
            .frame(width: geometry.size.width)
            .frame(minHeight: geometry.size.height)
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
    
    // First-time load shows progress HUD over the screen
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
    
    // Refreshing after first-time load does not display progress HUD over the screen
    func refreshLeaderboard() {
        // Success completion
        let onSuccess = {
            // scoringObj passed by reference and updated
            self.leagueLeaderboard.franchises = LeagueLeaderboard(scoringObj: self.scoringObj).franchises
        }
        // Error completion
        let onFailure = {}
        MflController.apiGetScoring(forLeague: self.activeLeague,
                                           intoObject: self.scoringObj,
                                           onSuccess: onSuccess,
                                           onFailure: onFailure)
    }
    
}

struct FranchiseTableCell: View {
    
    var rank: Int
    var franchise: LeaderboardFranchise
    
    var body: some View {
        HStack(alignment: .center, spacing: nil) {
            // Rank
            Image(systemName: "\(rank+1).circle.fill")
                .font(.title3)
                .frame(minWidth: 16)
            Text(String(format: "%.1f", franchise.totalScore))
                .font(.body)
                .fontWeight(.semibold)
                .frame(minWidth: 60)
            Divider()
            // Players Remaining
            Image(systemName: "person.2.circle.fill")
                .font(.title3)
                .frame(minWidth: 16)
            // TODO:
            Text("18")
                .font(.body)
                .frame(minWidth: 18)
            Divider()
            // Name
            Text(franchise.name.prefix(18))
                .font(.body)
        }
    }
    
}
