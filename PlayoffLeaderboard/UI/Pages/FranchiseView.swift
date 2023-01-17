//
//  FranchiseView.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/21/22.
//

import Foundation
import SwiftUI

struct FranchiseView: View {
    
    // Active Team
    var teamName: String
    var activeLeague: League
        
    // Only used temporarily for initializing the view
    var tempFranchise:LiveScoringFranchise
    var tempScoringObj:LeagueScoringObj
    
    // State variables
    @State private var isLoading: Bool = false
    @StateObject var franchiseLeaderboard = FranchiseLeaderboard()
    
    init(withTeam: String, forFranchise: LiveScoringFranchise, inLeague: League) {
        self.teamName = withTeam
        self.tempFranchise = forFranchise
        self.tempScoringObj = LeagueScoringObj()
        self.activeLeague = inLeague
        UINavigationBar.appearance().largeTitleTextAttributes
            = [.foregroundColor: UIColor(named: "AppNavy") ?? .black]
        UINavigationBar.appearance().titleTextAttributes
            = [.foregroundColor: UIColor(named: "AppNavy") ?? .black]
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            GeometryReader { geometry in
                VStack {
                    List {
                        Section {
                            let myPlayers = franchiseLeaderboard.franchise.players.player
                            if myPlayers.count > 0 {
                                ForEach(0 ..< myPlayers.count, id: \.self) { index in
                                    PlayerScoringTableCell(player: myPlayers[index])
                                }
                            }
                            else
                            {
                                Text("") // Placeholder
                            }
                        } header: {
                            Text("Live Scoring")
                        }
                    }
                    .listStyle(.grouped)
                    .foregroundColor(Color("AppNavy"))
                    .disabled(isLoading)
                    .blur(radius: isLoading ? 2 : 0)
                    .refreshable {
                        // Success completion
                        let onSuccess = {
                            // scoringObj passed by reference and updated
                            let tempLeaderboard = LeagueLeaderboard()
                            tempLeaderboard.franchises = LeagueLeaderboard(scoringObj: self.tempScoringObj).franchises
                            for franchise in tempLeaderboard.franchises {
                                if franchise.name == self.teamName {
                                    franchiseLeaderboard.franchise = franchise.liveScoring
                                }
                            }
                        }
                        // Error completion
                        let onFailure = {}
                        MflController.apiGetScoring(forLeague: self.activeLeague,
                                                    intoObject: self.tempScoringObj,
                                                    onSuccess: onSuccess,
                                                    onFailure: onFailure)
                    }
                }
                .padding(.top, 5)
                .background(Color(UIColor.secondarySystemBackground)) // also works in dark theme
                .frame(width: geometry.size.width)
                .frame(minHeight: geometry.size.height)
            }
            
            // Loading HUD
            if isLoading {
                LoadingDialogView()
            }
        }
        .navigationTitle(teamName)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            franchiseLeaderboard.franchise = tempFranchise
        }
    }
    
}

struct PlayerScoringTableCell: View {
    
    var player: LiveScoringPlayer
    
    var body: some View {
        HStack(alignment: .center, spacing: nil) {
            // Position
            Text(player.position.uppercased())
                .font(.body)
                .foregroundColor(Color("AccentColor"))
                .frame(minWidth: 25)
            Divider()
            // Score
            Text(player.score)
                .font(.body)
                .fontWeight(.bold)
                .frame(minWidth: 60)
            Divider()
            // Player
            VStack(alignment: .leading, spacing: nil) {
                Text(player.name + " (" + player.team + ")")
                    .font(.body)
                Text(player.matchup).font(.caption)
            }
        }
    }
    
}
