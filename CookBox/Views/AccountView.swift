//
//  AccountView.swift
//  CookBox
//
//  Created by Kishan on 2026-07-13.
//

import SwiftUI

struct AccountView: View {
    var body: some View {
        ZStack() {
            Color("AppBackground")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    VStack(spacing: 10) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 75))
                            .foregroundColor(.accentColor)

                        Text("CookBox User")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("Your personal recipe collection")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(28)
                    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 30))

                    Text("Your CookBox")
                        .font(.title2)
                        .fontWeight(.bold)

                    VStack(alignment: .leading, spacing: 16) {
                        Label("Personal recipe collection", systemImage: "book.closed")

                        Divider()

                        Label("Favourite recipes", systemImage: "heart")

                        Divider()

                        Label("Account settings coming soon", systemImage: "gearshape")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 30))
                }
                .padding(20)
            }

        }
    }
}

#Preview {
    AccountView()
}
