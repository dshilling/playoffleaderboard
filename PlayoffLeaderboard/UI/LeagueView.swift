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
    
    init(withLeague: League) {
        league = withLeague
    }
    
    var body: some View {
        VStack {
            Text("League leaderboard will go here.")
        }
        .foregroundColor(Color("AppNavy"))
        .navigationTitle(league.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
}
