//
//  PlayoffLeaderboardApp.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/16/22.
//

import SwiftUI

@main
struct PlayoffLeaderboardApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// Shared function that will dismiss the active keyboard programatically
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
