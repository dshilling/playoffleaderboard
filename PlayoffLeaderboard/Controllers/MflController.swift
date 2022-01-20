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
                     onFailure: @escaping () -> Void)
    {
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
                        onFailure: @escaping () -> Void)
    {
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
                var myLeagues = Leagues()
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let leaguesObj = try decoder.decode(LeaguesObj.self, from: data)
                    myLeagues = leaguesObj.leagues.league
                    print("Leagues: Successfully fetched", myLeagues.count, "leagues for user")
                    onSuccess(myLeagues)
                } catch {
                    print("Leagues: JSON deserialization failed:", String(decoding: data, as: UTF8.self))
                    onFailure()
                }
            }
        }
    }
    
    static func apiUpdateLeaderboard(forLeague: League,
                                     toLeaderboard: LeagueLeaderboard,
                                     onSuccess: @escaping () -> Void,
                                     onFailure: @escaping () -> Void)
    {
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
                toLeaderboard.leagueDetails = decodedData.league
                print("League: Successfully fetched league details for league", decodedData.league.id)
                // Continue to next request
                apiUpdateLeaderboardStandings(forLeague: forLeague, toLeaderboard: toLeaderboard, onSuccess: onSuccess, onFailure: onFailure)
            } catch {
                print("League: JSON deserialization failed:", String(decoding: data, as: UTF8.self))
                onFailure()
            }
        }
    }

    
// MARK: - Private methods
    
    // Truncate the URL returned by the myLeagues API to just the api base
    private static func getBaseUrl(forLeague: League) -> String {
        // "https://www69.myfantasyleague.com/2021/home/51911"
        return forLeague.url.components(separatedBy: "home")[0]
    }
    
    // Continue leaderboard request by fetching leagueStandings next
    static func apiUpdateLeaderboardStandings(forLeague: League,
                                              toLeaderboard: LeagueLeaderboard,
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
                toLeaderboard.leagueStandings = decodedData.leagueStandings
                print("League Standings: Successfully fetched standings for", decodedData.leagueStandings.franchise.count, "franchises")
                // Continue to next request
                apiUpdateLeaderboardScoring(forLeague: forLeague, toLeaderboard: toLeaderboard, onSuccess: onSuccess, onFailure: onFailure)
            } catch {
                print("League Standings: JSON deserialization failed:", String(decoding: data, as: UTF8.self))
                onFailure()
            }
        }
    }
    
    // Continue leaderboard request by fetching liveScoring next
    static func apiUpdateLeaderboardScoring(forLeague: League,
                                            toLeaderboard: LeagueLeaderboard,
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
                    toLeaderboard.liveScoring = decodedData.liveScoring
                    print("Live Scoring: Successfully fetched standings for", decodedData.liveScoring.franchise.count, "franchises")
                    onSuccess()
                } catch {
                    print("Live Scoring: JSON deserialization failed:", String(decoding: data, as: UTF8.self))
                    onFailure()
                }
            }
        }
    }
    
}
