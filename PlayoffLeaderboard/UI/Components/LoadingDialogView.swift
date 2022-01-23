//
//  LoadingDialogView.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/19/22.
//

import SwiftUI

struct LoadingDialogView: View {
    var body: some View {
        // This rectangle darkens the screen behind during loading.
        // For now, I decided I don't like the way this effect looks
        //Rectangle()
        //    .fill(Color.black) // Should convert to an Asset color
        //    .opacity(0.6)
        //    .edgesIgnoringSafeArea(.all)
        VStack(spacing: 48) {
            ProgressView()
                .scaleEffect(2.0, anchor: .center)
                .foregroundColor(Color("AppNavy"))
            Text("Loading")
                .font(.title)
                .foregroundColor(Color("AppNavy"))
                .fontWeight(.semibold)
        }
        .frame(width: 250, height: 200)
        .background(Color("AppGray"))
        .foregroundColor(Color("AppNavy"))
        .cornerRadius(16)
    }
}
