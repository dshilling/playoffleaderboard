//
//  ContentView.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/18/22.
//

import Foundation
import SwiftUI

struct ContentView: View {
    
    @State private var isLoggedIn: Bool = false
    @StateObject var myLeagues = MyLeagues()
    
    init() {
        // Set title text color
        UINavigationBar.appearance().largeTitleTextAttributes
            = [.foregroundColor: UIColor(named: "AppNavy") ?? .black]
        UINavigationBar.appearance().titleTextAttributes
            = [.foregroundColor: UIColor(named: "AppNavy") ?? .black]
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // NavigationLink for LeaguesView
                NavigationLink(destination: LeaguesView(), isActive: $isLoggedIn) { EmptyView() }
                // Start with the login view
                LoginView(isLoggedIn: $isLoggedIn)
                    .navigationTitle("Login")
                    .navigationBarHidden(true)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(myLeagues)
    }
    
}

struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
