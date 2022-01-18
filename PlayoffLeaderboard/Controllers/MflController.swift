//
//  MflController.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/18/22.
//

import Foundation

class MflController {
    
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
                HTTPCookieStorage.shared.setCookie(cookie)
            }
            // Test Cookie By Retreiving Leagues
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
                      DispatchQueue.main.async {
                          onFailure()
                      }
                      return
            }
            // Handle success
            DispatchQueue.main.async {
                // TODO: SUCCESS
                var myLeagues = Leagues()
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let leaguesObj = try decoder.decode(LeaguesObj.self, from: data)
                    myLeagues = leaguesObj.leagues.league
                } catch {
                    print("Leagues: JSON deserialization failed")
                }
                onSuccess(myLeagues)
            }
        }
    }

}
