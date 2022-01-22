//
//  MflController.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/18/22.
//

import Foundation

class MflController {
    
    static func apiLogout() {
        // Per MFL docs, all we have to do is delete the cookie
        HTTPCookieStorage.shared.cookies?.forEach(HTTPCookieStorage.shared.deleteCookie)
    }
    
    static func apiTryLogin(username: String,
                     password: String,
                     onSuccess: @escaping (Leagues) -> Void,
                     onFailure: @escaping () -> Void) {
        MflService.postLogin(username: username, password: password)
        {data, response, error in
            // Check for errors
            guard let data = data,
                  let response = response,
                  error == nil,
                  String(decoding: data, as: UTF8.self).contains("MFL_USER_ID") else {
                      print("Login: error response from the server")
                      DispatchQueue.main.async {
                          onFailure()
                      }
                      return
            }
            // Save session cookie
            let httpResponse:HTTPURLResponse = response as! HTTPURLResponse
            let httpHeaders: [String:String] = httpResponse.allHeaderFields as! [String:String]
            let httpCookies = HTTPCookie.cookies(withResponseHeaderFields: httpHeaders,
                                                 for: response.url ?? URL(string: "")!)
            for cookie in httpCookies {
                if cookie.name == "MFL_USER_ID" {
                    // MFL returns a session cookie. We want one that doesn't expire for a few months
                    let cookieProps: [HTTPCookiePropertyKey : Any] = [
                        HTTPCookiePropertyKey.domain: cookie.domain,
                        HTTPCookiePropertyKey.path: cookie.path,
                        HTTPCookiePropertyKey.name: cookie.name,
                        HTTPCookiePropertyKey.value: cookie.value,
                        HTTPCookiePropertyKey.secure: cookie.isSecure,
                        HTTPCookiePropertyKey.expires: NSDate(timeIntervalSinceNow: TimeInterval(60 * 60 * 24 * 90)) // 90 days
                    ]
                    let unexpiringCookie = HTTPCookie(properties: cookieProps)!
                    HTTPCookieStorage.shared.setCookie(unexpiringCookie)
                }
            }
            // Test Cookie By Retreiving Leagues
            print("Login: Successfully logged in user")
            MflController.apiTestSession(onSuccess: onSuccess, onFailure: onFailure)
        }
    }

    static func apiTestSession(onSuccess: @escaping (Leagues) -> Void,
                        onFailure: @escaping () -> Void) {
        MflService.exportMyLeagues()
        {data, response, error in
            // Check for errors
            guard let data = data,
                  let response = response,
                  error == nil,
                  (response as! HTTPURLResponse).statusCode == 200 else {
                      print("Leagues: error response from the server")
                      DispatchQueue.main.async {
                          onFailure()
                      }
                      return
            }
            // Handle success
            DispatchQueue.main.async {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let leaguesObj = try decoder.decode(LeaguesObj.self, from: data)
                    var myLeagues = Leagues()
                    myLeagues = leaguesObj.leagues
                    print("Leagues: Successfully fetched", myLeagues.league.count, "leagues for user")
                    DispatchQueue.main.async {
                        onSuccess(myLeagues)
                    }
                } catch {
                    print("Leagues: JSON deserialization failed:", String(decoding: data, as: UTF8.self))
                    DispatchQueue.main.async {
                        onFailure()
                    }
                }
            }
        }
    }
    
    static func apiGetScoring(forLeague: League,
                              intoObject: LeagueScoringObj,
                              onSuccess: @escaping () -> Void,
                              onFailure: @escaping () -> Void) {
        // Begin by fetching MFL status to get current year and week data
        MflService.getMflStatus()
        {data, response, error in
            // Check for errors
            guard let data = data,
                  let response = response,
                  error == nil,
                  (response as! HTTPURLResponse).statusCode == 200 else {
                      print("API Status: error response from the server")
                      DispatchQueue.main.async {
                          onFailure()
                      }
                      return
            }
            // Handle success
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let decodedData = try decoder.decode(MflStatusResponse.self, from: data)
                intoObject.mflStatus = decodedData.mflStatus
                print("API Status: Successfully fetched API status")
                // Continue to next request
                apiGetScoringLeague(forLeague: forLeague, intoObject: intoObject, onSuccess: onSuccess, onFailure: onFailure)
            } catch {
                print("API Status: JSON deserialization failed:", String(decoding: data, as: UTF8.self))
                DispatchQueue.main.async {
                    onFailure()
                }
            }
        }
    }
    
// MARK: - Private methods
    
    // Truncate the URL returned by the myLeagues API to just the api base
    private static func getBaseUrl(forLeague: League) -> String {
        // "https://www69.myfantasyleague.com/2021/home/51911"
        return forLeague.url.components(separatedBy: "home")[0]
    }
    
    // Continue scoring request by fetching league next
    static func apiGetScoringLeague(forLeague: League,
                                    intoObject: LeagueScoringObj,
                                    onSuccess: @escaping () -> Void,
                                    onFailure: @escaping () -> Void) {
        // Begin by fetching league details
        MflService.exportLeague(leagueBaseUrl: getBaseUrl(forLeague: forLeague), leagueId: forLeague.leagueId)
        {data, response, error in
            // Check for errors
            guard let data = data,
                  let response = response,
                  error == nil,
                  (response as! HTTPURLResponse).statusCode == 200 else {
                      print("League: error response from the server")
                      DispatchQueue.main.async {
                          onFailure()
                      }
                      return
            }
            // Handle success
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let decodedData = try decoder.decode(LeagueDetailsResponse.self, from: data)
                intoObject.leagueDetails = decodedData.league
                print("League: Successfully fetched league details for league", decodedData.league.id)
                // Continue to next request
                apiGetScoringStandings(forLeague: forLeague, intoObject: intoObject, onSuccess: onSuccess, onFailure: onFailure)
            } catch {
                print("League: JSON deserialization failed:", String(decoding: data, as: UTF8.self))
                DispatchQueue.main.async {
                    onFailure()
                }
            }
        }
    }
    
    // Continue scoring request by fetching leagueStandings next
    static func apiGetScoringStandings(forLeague: League,
                                       intoObject: LeagueScoringObj,
                                       onSuccess: @escaping () -> Void,
                                       onFailure: @escaping () -> Void)
    {
        MflService.exportLeagueStandings(leagueBaseUrl: getBaseUrl(forLeague: forLeague), leagueId: forLeague.leagueId)
        {data, response, error in
            // Check for errors
            guard let data = data,
                  let response = response,
                  error == nil,
                  (response as! HTTPURLResponse).statusCode == 200 else {
                      print("League Standings: error response from the server")
                      DispatchQueue.main.async {
                          onFailure()
                      }
                      return
            }
            // Handle success
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let decodedData = try decoder.decode(LeagueStandingsResponse.self, from: data)
                intoObject.leagueStandings = decodedData.leagueStandings
                print("League Standings: Successfully fetched standings for", decodedData.leagueStandings.franchise.count, "franchises")
                // Continue to next request
                apiGetScoringLive(forLeague: forLeague, intoObject: intoObject, onSuccess: onSuccess, onFailure: onFailure)
            } catch {
                print("League Standings: JSON deserialization failed:", String(decoding: data, as: UTF8.self))
                DispatchQueue.main.async {
                    onFailure()
                }
            }
        }
    }
    
    // Continue scoring request by fetching liveScoring next
    static func apiGetScoringLive(forLeague: League,
                                  intoObject: LeagueScoringObj,
                                  onSuccess: @escaping () -> Void,
                                  onFailure: @escaping () -> Void)
    {
        MflService.exportLiveScoring(leagueBaseUrl: getBaseUrl(forLeague: forLeague), leagueId: forLeague.leagueId)
        {data, response, error in
            // Check for errors
            guard let data = data,
                  let response = response,
                  error == nil,
                  (response as! HTTPURLResponse).statusCode == 200 else {
                      print("Live Scoring: error response from the server")
                      DispatchQueue.main.async {
                          onFailure()
                      }
                      return
            }
            // Handle success
            DispatchQueue.main.async {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let decodedData = try decoder.decode(LiveScoringResponse.self, from: data)
                    intoObject.liveScoring = decodedData.liveScoring
                    print("Live Scoring: Successfully fetched standings for", decodedData.liveScoring.franchise.count, "franchises")
                    // Continue to next request
                    localGetPlayers(intoObject: intoObject, onSuccess: onSuccess, onFailure: onFailure)
                } catch {
                    print("Live Scoring: JSON deserialization failed:", String(decoding: data, as: UTF8.self))
                    DispatchQueue.main.async {
                        onFailure()
                    }
                }
            }
        }
    }
    
    // Continue scoring request by fetching players next
    static func localGetPlayers(intoObject: LeagueScoringObj,
                                onSuccess: @escaping () -> Void,
                                onFailure: @escaping () -> Void) {
        // TODO: This won't work next year when new players join the league, use api instead:
        // export?TYPE=players&L=1234&JSON=1
        do {
            guard let path = Bundle.main.path(forResource: "players", ofType: "json") else {
                print("Players: error loading local json file")
                DispatchQueue.main.async {
                    onFailure()
                }
                return
            }
            let jsonData = try String(contentsOfFile: path).data(using: .utf8)
            let decodedData = try JSONDecoder().decode(PlayersResponse.self, from: jsonData ?? Data())
            // Build dictionary
            var dict: [String:Player] = [:]
            for player in decodedData.players.player {
                dict[player.id] = player
            }
            intoObject.mflPlayers = dict
            print("Players: Successfully fetched ", dict.count, "players")
            DispatchQueue.main.async {
                onSuccess()
            }
        } catch {
            print("Players: JSON deserialization failed for local file")
            DispatchQueue.main.async {
                onFailure()
            }
        }
    }
    
}
