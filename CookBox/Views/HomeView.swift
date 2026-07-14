//
//  ReceivedView.swift
//  CookBox
//
//  Created by Kishan on 2026-07-13.
//

import SwiftUI

struct HomeView: View {
    @State private var showingSheet = false
    @State private var colorDark = Color(red: 20 / 255, green: 17 / 255, blue: 15 / 255)
    @State private var colorLight = Color(red: 237 / 255, green: 242 / 255, blue: 244 / 255)
    @Environment(\.colorScheme) var colorScheme
    
    let today = Date.now
        
    var body: some View {
        
        NavigationStack() {
            ZStack {
                
                if colorScheme == .dark {
                    colorDark
                        .ignoresSafeArea()

                } else {
                    colorLight
                        .ignoresSafeArea()
                }
                
                
                ScrollView() {
                    VStack(alignment: .leading) {
                        Text(today.formatted(.dateTime.weekday(.wide).month(.wide).day()))
                            .padding(.leading, 25)
                            .autocapitalization(.allCharacters)
                            
                        HStack() {
                            Text("Your Cookbook")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 25)
                                
                            Spacer()
                        }
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    showingSheet = true
                                } label: {
                                    Label("Add", systemImage: "plus")
                                }
                            }
                        }
                        .sheet(isPresented: $showingSheet) {
                            // Content of your bottom sheet
                            Text("This is your bottom sheet")
                        }
                    }
                }
                
                
            }
            
        }
    }
}
#Preview {
    HomeView()
}
