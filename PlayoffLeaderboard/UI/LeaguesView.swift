//
//  LeaguesView.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/18/22.
//

import Foundation
import SwiftUI

struct LeaguesView: View {
    
    // Environment Objects
    @EnvironmentObject var myLeagues: MyLeagues

    var body: some View {
        VStack {
            Text("My Leagues:")
            if myLeagues.leagues.count > 0 {
                ForEach(0 ..< myLeagues.leagues.count) { index in
                    Text(myLeagues.leagues[index].name)
                }
            }
        }
    }
    
}
