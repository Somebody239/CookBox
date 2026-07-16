//
//  ContentView.swift
//  CookBox
//
//  Created by Kishan on 2026-07-12.
//

import SwiftUI
import SwiftData

@available(iOS 26.0, *)
struct ContentView: View {

    var body: some View {

        ZStack () {

            Color.red
                .ignoresSafeArea()

            TabView {
                Tab("Home", systemImage: "house.fill") {
                    HomeView()
                }

                Tab("Search", systemImage: "magnifyingglass") {
                    SearchView()
                }

                Tab("Account", systemImage: "person.crop.circle.fill") {
                    AccountView()
                }
            }






        }





    }

}



#Preview {
    if #available(iOS 26.0, *) {
        ContentView()
            .modelContainer(for: Recipe.self, inMemory: true)
    } else {
        // Fallback on earlier versions
    }
}
