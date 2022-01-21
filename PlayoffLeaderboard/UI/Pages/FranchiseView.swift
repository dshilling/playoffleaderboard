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
        
    // Only used temporarily for initializing the view
    var tempFranchise:LiveScoringFranchise
    
    // State variables
    @State private var isLoading: Bool = false
    @StateObject var franchiseLeaderboard = FranchiseLeaderboard()
    
    init(withTeam: String, forFranchise: LiveScoringFranchise) {
        self.teamName = withTeam
        self.tempFranchise = forFranchise
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            GeometryReader { geometry in
                VStack {
                    List {
                        Section {
                            let myPlayers = franchiseLeaderboard.franchise.players.player
                            if myPlayers.count > 0 {
                                ForEach(0 ..< myPlayers.count) { index in
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
                    // TODO: Pull down refresh not yet supported
                    //.refreshable {}
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
            Text(player.position)
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
            Text(player.name + " (" + player.team + ")")
                .font(.body)
        }
    }
    
}
