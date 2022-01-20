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
    
    static func apiUpdateLeaderboard(onSuccess: @escaping () -> Void,
                                     onFailure: @escaping () -> Void)
    {
        // TODO: Complete this
    }

}
