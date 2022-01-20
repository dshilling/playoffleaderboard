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
    var league: League
    
    // State variables
    @State private var isLoading: Bool = false
    
    init(withLeague: League) {
        league = withLeague
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
        .navigationTitle(league.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
}
