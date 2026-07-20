//
//  ContentView.swift
//  CookBox
//
//  Created by Kishan on 2026-07-12.
//

import SwiftUI
import SwiftData

private enum Tabs: Hashable {
    case home
    case account
    case search
}

@available(iOS 26.0, *)
struct ContentView: View {
    @State private var selectedTab: Tabs = .home
    @State private var searchText = ""

    var body: some View {

        ZStack () {

            Color.red
                .ignoresSafeArea()

            TabView(selection: $selectedTab) {
                Tab("Home", systemImage: "house.fill", value: Tabs.home) {
                    HomeView()
                }

                Tab("Account", systemImage: "person.crop.circle.fill", value: Tabs.account) {
                    AccountView()
                }

                Tab(value: Tabs.search, role: .search) {
                    NavigationStack {
                        SearchView(searchText: $searchText)
                    }
                    .searchable(text: $searchText, prompt: "Search recipes...")
                }
            }
            .tabViewSearchActivation(.searchTabSelection)






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
