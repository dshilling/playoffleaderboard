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
    @EnvironmentObject var myLeagues: MyLeagues
        
    var body: some View {
        VStack {
            Text("League selected.")
        }
        .foregroundColor(Color("AppNavy"))
        .navigationTitle(myLeagues.league!.name)
    }
    
}
