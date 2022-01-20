//
//  LeagueView.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/18/22.
//

import Foundation
import SwiftUI

struct LeagueView: View {
    
    // Environment Objects
    var leagueId: String
    
    // State variables
    @State private var isLoading: Bool = false
    @StateObject var leaderboard = LeagueLeaderboard()
    
    init(withLeagueId: String) {
        leagueId = withLeagueId
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack {
                Text("League leaderboard will go here.")
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
        .navigationTitle(leagueId)
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
            MflController.apiUpdateLeaderboard(onSuccess: onSuccess, onFailure: onFailure)
        }
    }
    
}
