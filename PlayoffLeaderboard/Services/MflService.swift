//
//  MflService.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/16/22.
//

import Foundation

class MflService {
        
    // Configuration Constants
    static let baseUrl = "https://api.myfantasyleague.com/" + getLeagueYear() + "/"
    
    // POST /login
    // https://api.myfantasyleague.com/2021/api_info?STATE=test&CCAT=misc&TYPE=login
    static func postLogin(username: String,
                   password: String,
                   completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        // Request
        let url = URL(string: baseUrl + "login")!
        var paramString: String = "USERNAME=\(username)&PASSWORD=\(password)&XML=1"
        paramString = paramString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let paramData : Data = paramString.data(using: .utf8)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = paramData
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
        // Session
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
    
    // GET MFL Status
    // https://api.myfantasyleague.com/fflnetdynamic2021/mfl_status.json
    static func getMflStatus(completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let url = URL(string: "https://api.myfantasyleague.com/fflnetdynamic" + getLeagueYear() + "/mfl_status.json")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
    
    // GET NFL Schedule
    // https://api.myfantasyleague.com/fflnetdynamic2020/nfl_sched_19.json
    static func getNflSchedule(week: String,
                               completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let urlStr = "https://api.myfantasyleague.com/fflnetdynamic" + getLeagueYear() + "/nfl_sched_" + week + ".json"
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
    
    // EXPORT myleagues
    // https://api.myfantasyleague.com/2021/api_info?STATE=test&CCAT=export&TYPE=myleagues
    static func exportMyLeagues(completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let url = baseUrl + "export?TYPE=myleagues&YEAR=" + getLeagueYear() + "&FRANCHISE_NAMES=1&JSON=1"
        exportRequest(urlStr: url, completion: completion)
    }
    
    // EXPORT league
    // https://api.myfantasyleague.com/2021/api_info?STATE=test&CCAT=export&TYPE=league
    static func exportLeague(leagueBaseUrl: String, leagueId: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        exportLeagueProperty(leagueBaseUrl: leagueBaseUrl, leagueId: leagueId, leagueProperty: "league", completion: completion)
    }
    
    // EXPORT leagueStandings
    // https://api.myfantasyleague.com/2021/api_info?STATE=test&CCAT=export&TYPE=leagueStandings
    static func exportLeagueStandings(leagueBaseUrl: String, leagueId: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        exportLeagueProperty(leagueBaseUrl: leagueBaseUrl, leagueId: leagueId, leagueProperty: "leagueStandings", completion: completion)
    }
    
    // EXPORT liveScoring
    // https://api.myfantasyleague.com/2021/api_info?STATE=test&CCAT=export&TYPE=liveScoring
    static func exportLiveScoring(leagueBaseUrl: String, leagueId: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        exportLeagueProperty(leagueBaseUrl: leagueBaseUrl, leagueId: leagueId, leagueProperty: "liveScoring", completion: completion)
    }
    
// MARK: - Private methods
    
    static private func getLeagueYear() -> String {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        if (month < 3) { // Jan - March
            return String(year - 1);
        } else {
            return String(year);
        }
    }
    
    static private func exportLeagueProperty(leagueBaseUrl: String, leagueId: String, leagueProperty: String,
                                             completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
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
