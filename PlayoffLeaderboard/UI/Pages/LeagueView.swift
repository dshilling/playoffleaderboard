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
    @StateObject var leaderboard = LeagueLeaderboard()
    
    init(withLeague: League) {
        self.activeLeague = withLeague
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack {
                // TODO: Complete This Section
                Text("Teams:")
                ForEach((leaderboard.leagueDetails?.franchises.franchise)!, id:\.self) {franchise in
                    Text(franchise.id + ", " + franchise.name)
                }
                Text("Teams:")
                ForEach((leaderboard.leagueStandings?.franchise)!, id:\.self) {franchise in
                    Text(franchise.id + ", " + franchise.pf)
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
                // leaderboard passed by reference and updated
                self.isLoading = false
            }
            // Error completion
            let onFailure = {
                self.isLoading = false
            }
            MflController.apiUpdateLeaderboard(forLeague: self.activeLeague,
                                               toLeaderboard: self.leaderboard,
                                               onSuccess: onSuccess,
                                               onFailure: onFailure)
        }
    }
    
}
