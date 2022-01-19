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
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(myLeagues)
    }
    
    init() {
        // Set title text color
        let navBarAppearance = UINavigationBar.appearance()
        let appNavy = UIColor(red:CGFloat(Float(0x14)/255.0), green:CGFloat(Float(0x14)/255.0), blue:CGFloat(Float(0x23)/255.0), alpha:1)
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: appNavy]
        navBarAppearance.titleTextAttributes = [.foregroundColor: appNavy]
    }
    
}
