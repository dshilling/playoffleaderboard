//
//  ContentView.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/16/22.
//

import SwiftUI

struct LoadingView<Content>: View where Content: View {

    @Binding var isLoading: Bool
    var content: () -> Content
    
    var body: some View {
        ZStack(alignment: .center) {
            // Pass underlying view content to display here
            content()
                .disabled(isLoading)
                .blur(radius: isLoading ? 2 : 0)
            // Loading HUD
            if isLoading {
                ProgressHUD(isLoading: $isLoading)
            }
        }
    }
}

struct ProgressHUD: View {
    @Binding var isLoading:Bool
    var body: some View {
        Rectangle()
            .fill(Color.black).opacity(isLoading ? 0.6 : 0)
            .edgesIgnoringSafeArea(.all)
        VStack(spacing: 48) {
            ProgressView().scaleEffect(2.0, anchor: .center)
            Text("Loading").font(.title).fontWeight(.semibold)
        }
        .frame(width: 250, height: 200)
        .background(Color.white)
        .foregroundColor(Color.primary)
        .cornerRadius(16)
    }
}

struct LoginView: View {
    
    // Services
    var service = MflApiImpl.init()
    
    // Login form
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var loginError: Bool = false
    @State private var isLoading: Bool = false
    
    var body: some View {
        LoadingView(isLoading: $isLoading) {
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
                    service.postLogin(username: username,
                                      password: password)
                    {data, response, error in
                        isLoading = false
                        // TODO handle response
                        if ((data != nil) && (error != nil)
                            && (String(decoding: data!, as: UTF8.self).contains("MFL_USER_ID"))) {
                            // TODO Handle success
                            print(String(decoding: data!, as: UTF8.self))
                        } else {
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
