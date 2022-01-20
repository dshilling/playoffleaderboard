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
    
    // Needed for custom back button
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        
    var body: some View {
        List {
            Section {
                if myLeagues.leagues.count > 0 {
                    ForEach(0 ..< myLeagues.leagues.count) { index in
                        let league = myLeagues.leagues[index]
                        NavigationLink(destination: LeagueView(withLeagueId: league.leagueId)) {
                            Label(league.name, systemImage: "arrow.right.circle.fill" )
                                .font(.title3)
                        }
                    }
                }
            } header: {
                Text("My Leagues")
            }
        }
        .listStyle(.grouped)
        .foregroundColor(Color("AppNavy"))
        .navigationTitle("Select League")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnLogout)
    }
    
    // Replace back button with custom logout button
    var btnLogout: some View {
        Button(action: logout) {
            HStack {
                Image(systemName: "arrowshape.turn.up.left.fill")
                    .font(.caption)
                Text("Logout")
            }
        }
    }
    
    // Handles the logout action
    func logout() {
        MflController.apiLogout()
        self.presentationMode.wrappedValue.dismiss()
    }
    
}
