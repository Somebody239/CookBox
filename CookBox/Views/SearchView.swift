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
    @Binding var searchText: String
    @Query private var recipes: [Recipe]

    init(searchText: Binding<String>) {
        self._searchText = searchText
    }

    var body: some View {
        ZStack {
            Color("AppBackground")
                .ignoresSafeArea()
            VStack() {
                ScrollView { //Recipies
                    LazyVStack(spacing: 14) {
                        ForEach(recipes) { recipe in
                            if recipe.name.localizedCaseInsensitiveContains(searchText) || searchText.isEmpty {
                                NavigationLink {
                                    RecipeView(recipe: recipe)
                                } label: {
                                    recipeCard(for: recipe)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                }
            }
        }
    }

    //Recipe Card Design
    private func recipeCard(for recipe: Recipe) -> some View {
        HStack {
            if let imageData = recipe.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            }
            Text(recipe.name)
                .font(.headline)

            Spacer()

            Image(systemName: "chevron.right")
        }
        .padding()
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 30))
        .cornerRadius(12)
    }
}


#Preview {
    SearchView(searchText: .constant(""))
        .modelContainer(for: Recipe.self, inMemory: true)
}
