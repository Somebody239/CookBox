//
//  SplashScreenView.swift
//  CookBox
//
//

import SwiftUI
//  Created for planning and design practice.
//  It is not used anywhere in the app.
//  LaunchScreen.storyboard is the launch screen currently being used.
struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 12) {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)

                Text("CookBox")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.white)

                Text("Your personal cookbook")
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
