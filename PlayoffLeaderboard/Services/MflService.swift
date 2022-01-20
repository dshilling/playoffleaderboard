//
//  MflService.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/16/22.
//

import Foundation

class MflService {
        
    // Configuration Constants
    static let baseUrl = "https://api.myfantasyleague.com/2021/"
    
    // POST /login
    // https://api.myfantasyleague.com/2021/api_info?STATE=test&CCAT=misc&TYPE=login
    static func postLogin(username: String,
                   password: String,
                   completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        // Request
        let url = URL(string: baseUrl + "login")!
        let paramData : Data = "USERNAME=\(username)&PASSWORD=\(password)&XML=1".data(using: .utf8)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = paramData
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
        // Session
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
    
    // EXPORT myleagues
    // https://api.myfantasyleague.com/2021/api_info?STATE=test&CCAT=export&TYPE=myleagues
    static func exportMyLeagues(completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let url = baseUrl + "export?TYPE=myleagues&YEAR=2021&FRANCHISE_NAMES=1&JSON=1"
        exportRequest(urlStr: url, completion: completion)
    }
    
    // EXPORT league
    // https://api.myfantasyleague.com/2021/api_info?STATE=test&CCAT=export&TYPE=league
    static func exportLeague(host: String, leagueId: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        exportLeagueProperty(host: host, leagueId: leagueId, leagueProperty: "league", completion: completion)
    }
    
    // EXPORT leagueStandings
    // https://api.myfantasyleague.com/2021/api_info?STATE=test&CCAT=export&TYPE=leagueStandings
    static func exportLeagueStandings(host: String, leagueId: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        exportLeagueProperty(host: host, leagueId: leagueId, leagueProperty: "leagueStandings", completion: completion)
    }
    
    // EXPORT liveScoring
    // https://api.myfantasyleague.com/2021/api_info?STATE=test&CCAT=export&TYPE=liveScoring
    static func exportLiveScoring(host: String, leagueId: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        exportLeagueProperty(host: host, leagueId: leagueId, leagueProperty: "liveScoring", completion: completion)
    }
    
// MARK: - Private methods
    
    static private func exportLeagueProperty(host: String, leagueId: String, leagueProperty: String,
                                             completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let leagueBaseUrl = baseUrl.replacingOccurrences(of: "api", with: host)
        let url = leagueBaseUrl + "export?TYPE=" + leagueProperty + "&L=" + leagueId + "&JSON=1"
        exportRequest(urlStr: url, completion: completion)
    }
    
    static private func exportRequest(urlStr: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
    
}
