//
//  ContentView.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/16/22.
//

import SwiftUI

struct LoginView: View {
    
    // Services
    var service = MflApiImpl.init()
    
    // Login form
    @State var username: String = ""
    @State var password: String = ""
    @State var loginError: Bool = false
    
    var body: some View {
        VStack {
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
                self.loginError = false
                service.postLogin(username: username,
                                  password: password)
                {data, response, error in
                    if (data != nil) {
                        print(String(decoding: data!, as: UTF8.self))
                    }
                    if (error != nil) {
                        self.loginError = true
                    }
                }
            }) {
                LoginButtonText()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct HeadingText: View {
    var body: some View {
        Text("Playoff Leaderboard")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 15)
    }
}

struct SubheadingText: View {
    var body: some View {
        Text("Follow your quest for glory in your [MFL](http://home.myfantasyleague.com/playoff-leagues) playoff fantasy football league")
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
