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
                VStack(spacing: 20) {
                    Text("Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(20)
                    
                    List {
                        
                        
                        
                    }
                        
                    
                }
            }

        }
    }
}

#Preview {
    AccountView()
}
