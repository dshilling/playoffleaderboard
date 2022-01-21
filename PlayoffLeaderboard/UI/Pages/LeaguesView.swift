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
                        NavigationLink(destination: LeagueView(withLeague: league)) {
                            LeagueTableCell(league: league)
                        }
                    }
                }
                else
                {
                    Text("") // Placeholder
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

struct LeagueTableCell: View {
    
    var league: League
    
    var body: some View {
        HStack(alignment: .center, spacing: nil) {
            Image(systemName: "person.2.circle.fill")
            Text(league.name)
                .font(.title3)
        }
    }
    
}
