//
//  FranchiseLeaderboard.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/21/22.
//

import Foundation

class FranchiseLeaderboard: ObservableObject {
    
    @Published var franchise: LiveScoringFranchise
    
    init() {
        franchise = LiveScoringFranchise()
    }
    
}
