//
//  ContentView.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/18/22.
//

import Foundation
import SwiftUI

struct ContentView: View {
    
    @State private var selectedView: String? = nil
    @StateObject var myLeagues = MyLeagues()
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: LeaguesView(),
                               tag: "LeaguesTag",
                               selection: $selectedView) { EmptyView() }
                // Start with the login view
                LoginView(selectedView: $selectedView)
                    .navigationTitle("Login")
                    .navigationBarHidden(true)
            }
        }
        .environmentObject(myLeagues)
    }
    
}
