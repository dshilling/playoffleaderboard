//
//  ContentView.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/16/22.
//

import SwiftUI

// MARK: - LoginView View Implementation

struct LoginView: View {
    
    // Login form
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var loginError: Bool = false
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack() {
                HeadingText()
                SubheadingText()
                LogoImage()
                UsernameField(username: $username)
                PasswordField(password: $password)
                if loginError {
                    ErrorText()
                } else {
                    // Keeps view from resizing on error
                    HiddenErrorText()
                }
                Button(action: {
                    isLoading = true
                    self.loginError = false
                    // Success completion
                    let onSuccess = { (leagues: Leagues) in
                        isLoading = false
                        // TODO: HANDLE SUCCESS
                        print("SUCCESS:")
                        for myLeague in leagues {
                            print(myLeague)
                        }
                    }
                    // Error completion
                    let onFailure = {
                        self.loginError = true
                        isLoading = false
                    }
                    apiTryLogin(username: username, password: password,
                                onSuccess: onSuccess, onFailure: onFailure)
                }) {
                    LoginButtonText()
                }
            }
            .padding()
            .disabled(isLoading)
            .blur(radius: isLoading ? 2 : 0)
            
            // Loading HUD
            if isLoading {
                ProgressHUD()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

// MARK: - Subviews

struct HeadingText: View {
    var body: some View {
        Text("Playoff Leaderboard")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .foregroundColor(Color("AppNavy"))
            .padding(.bottom, 15)
    }
}

struct SubheadingText: View {
    var body: some View {
        Text("Follow your quest for glory in your [MFL](http://home.myfantasyleague.com/playoff-leagues) playoff fantasy football league")
            .foregroundColor(Color("AppNavy"))
            .padding(.bottom, 20)
            .multilineTextAlignment(.center)
    }
}

struct LogoImage: View {
    var body: some View {
        Image("LeaderboardLogo")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            .clipped()
            .cornerRadius(150)
            .padding(.bottom, 35)
    }
}

struct UsernameField: View {
    @Binding var username: String
    var body: some View {
        TextField("Your MFL Username", text: $username)
            .autocapitalization(.none)
            .padding()
            .cornerRadius(5.0)
            .background(Color("AppGray"))
            .padding(.bottom, 10)
    }
}

struct PasswordField: View {
    @Binding var password: String
    var body: some View {
        SecureField("Your MFL Password", text: $password)
            .padding()
            .cornerRadius(5.0)
            .background(Color("AppGray"))
            .padding(.bottom, 20)
    }
}

struct ErrorText: View {
    var body: some View {
        Text("Login failed. Try again.")
            .offset(y: -10)
            .foregroundColor(Color("AccentColor"))
    }
}

// Keeps view from resizing on error
struct HiddenErrorText: View {
    var body: some View {
        Text(" ")
            .offset(y: -10)
    }
}

struct LoginButtonText: View {
    var body: some View {
        Text("LOGIN")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color("AccentColor"))
            .cornerRadius(15.0)
    }
}

struct ProgressHUD: View {
    var body: some View {
        Rectangle()
            .fill(Color.black)
            .opacity(0.6)
            .edgesIgnoringSafeArea(.all)
        VStack(spacing: 48) {
            ProgressView()
                .scaleEffect(2.0, anchor: .center)
            Text("Loading")
                .font(.title)
                .fontWeight(.semibold)
        }
        .frame(width: 250, height: 200)
        .background(Color.white)
        .foregroundColor(Color.primary)
        .cornerRadius(16)
    }
}

// MARK: - Private Methods

func apiTryLogin(username: String,
                 password: String,
                 onSuccess: @escaping (Leagues) -> Void,
                 onFailure: @escaping () -> Void)
{
    MflService.shared.postLogin(username: username, password: password)
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
        apiTestSession(onSuccess: onSuccess, onFailure: onFailure)
    }
}

func apiTestSession(onSuccess: @escaping (Leagues) -> Void,
                    onFailure: @escaping () -> Void)
{
    MflService.shared.exportMyLeagues()
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
