//
//  LoadingDialogView.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/19/22.
//

import SwiftUI

struct LoadingDialogView: View {
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
