//
//  MflService.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/16/22.
//

import Foundation

class MflService {
    
    // Singleton implementation
    static let shared = MflService()
    
    // Configuration Constants
    let baseUrl = "https://api.myfantasyleague.com/2021/"
    
    // POST /login
    func postLogin(username: String,
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
    
}
