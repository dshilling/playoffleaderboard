//
//  League.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/17/22.
//

import Foundation

// Observable class for managing application state
class MyLeagues: ObservableObject {
    
    // All leagues for this user
    @Published var leagues: Leagues
        
    init() {
        leagues = Leagues()
    }
    
}

// MFL API object
struct LeaguesObj: Codable {
    var leagues: Leagues
    init() {
        leagues = Leagues()
    }
}

struct Leagues: Codable {
    
    var league: [League]
    
    init() {
        league = [League]()
    }
    
    // Override Decoder method to handle cases where "league" is an object or a list
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.league = try values.decode([League].self, forKey: .league)
        } catch {
            let tempLeague: League = try values.decode(League.self, forKey: .league)
            self.league = [League]()
            self.league.append(tempLeague)
        }
    }
    
}

struct League: Codable {
    var franchiseId: String
    var url: String
    var name: String
    //var franchiseName: String
    var leagueId: String
    init() {
        franchiseId = ""
        url = ""
        name = ""
        //franchiseName = "" commissioners without a linked team will not have this field in response
        leagueId = ""
    }
}
