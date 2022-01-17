//
//  ContentView.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/16/22.
//

import SwiftUI

struct LoginView: View {
    
    // Login form
    @State var username: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack {
            HeadingText()
            SubheadingText()
            LogoImage()
            TextField("Your MFL Username", text: $username)
                .padding()
                .cornerRadius(5.0)
                .background(Color("AppGray"))
                .padding(.bottom, 10)
            SecureField("Your MFL Password", text: $password)
                .padding()
                .cornerRadius(5.0)
                .background(Color("AppGray"))
                .padding(.bottom, 20)
            Button(action: {print("Button tapped")}) {
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
