//
//  ReceivedView.swift
//  CookBox
//
//  Created by Kishan on 2026-07-13.
//

import SwiftUI
import SwiftData

@available(iOS 26.0, *)
struct HomeView: View {
    @State private var showingSheet = false
    let today = Date.now

    var body: some View {
        NavigationStack() {
            ZStack {
                Color("AppBackground")
                    .ignoresSafeArea()


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

                        // Rest of Home Page

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
                        AddRecipeView()
                    }



                }
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Recipe.self, inMemory: true)
}
