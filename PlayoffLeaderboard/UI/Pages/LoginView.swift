//
//  LoginView.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/16/22.
//

import SwiftUI

struct LoginView: View {
    
    // Environment Objects
    @EnvironmentObject var myLeagues: MyLeagues
    
    // Bindings
    @Binding var isLoggedIn: Bool
    
    // State variables
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var loginError: Bool = false
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack(alignment: .center) {
            GeometryReader { geometry in
            ScrollView {
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
                    // We get an error when modifying below state variables while TextField editing is ongoing
                    UIApplication.shared.endEditing()
                    // Try login
                    self.isLoading = true
                    self.loginError = false
                    // Success completion
                    let onSuccess = { (leagues: Leagues) in
                        self.isLoading = false
                        self.myLeagues.leagues = leagues
                        self.isLoggedIn = true
                    }
                    // Error completion
                    let onFailure = {
                        self.loginError = true
                        self.isLoading = false
                    }
                    MflController.apiTryLogin(username: username, password: password,
                                              onSuccess: onSuccess, onFailure: onFailure)
                }) {
                    LoginButtonText()
                }
            }
            .padding()
            .frame(width: geometry.size.width)
            .frame(minHeight: geometry.size.height)
            .disabled(self.isLoading)
            .blur(radius: self.isLoading ? 2 : 0)
            }
            }
            
            // Loading HUD
            if self.isLoading {
                LoadingDialogView()
            }
        }
        .onAppear {
            self.isLoggedIn = false
            // Check if user is logged in already
            self.isLoading = true
            // Success completion
            let onSuccess = { (leagues: Leagues) in
                self.isLoading = false
                self.myLeagues.leagues = leagues
                self.isLoggedIn = true
            }
            // Error completion
            let onFailure = {
                self.isLoading = false
            }
            MflController.apiTestSession(onSuccess: onSuccess, onFailure: onFailure)
        }
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
