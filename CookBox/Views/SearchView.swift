//
//  SentView.swift
//  CookBox
//
//  Created by Kishan on 2026-07-13.
//

import SwiftUI
import SwiftData

@available(iOS 26.0, *)
struct SearchView: View {
    @State private var searchText = ""
    @Query private var recipes: [Recipe]
    @Environment(\.modelContext) private var context

    var body: some View {
        NavigationStack() {
            ZStack {
                Color("AppBackground")
                    .ignoresSafeArea()
                VStack() {
                    ScrollView { //Recipies
                        LazyVStack(spacing: 14) {
                            ForEach(recipes) { recipe in
                                if recipe.recipeName.localizedCaseInsensitiveContains(searchText) || searchText.isEmpty {
                                    recipeCard(for: recipe)
                                }

                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 12)
                    }



                    HStack { // Search Bar
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search recipes...", text: $searchText)
                            .textFieldStyle(.plain)
                            .autocorrectionDisabled ()
                        if !searchText.isEmpty {
                            Button (action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(12)
                    .glassEffect()
                    .padding()
                }
            }
            .task {
                if recipes.isEmpty {
                    context.insert(Recipe(recipeName: "Creamy Tomato Pasta"))
                    context.insert(Recipe(recipeName: "Chicken Tacos"))
                    context.insert(Recipe(recipeName: "Blueberry Pancakes"))
                }
            }
        }
    }

    //Recipe Card Design
    private func recipeCard(for recipe: Recipe) -> some View {
        HStack {
            Text(recipe.recipeName)
                .font(.headline)

            Spacer()

            Image(systemName: "chevron.right")
        }
        .padding()
        .glassEffect()
        .cornerRadius(12)
    }
}


#Preview {
    SearchView()
        .modelContainer(for: Recipe.self, inMemory: true)
}
