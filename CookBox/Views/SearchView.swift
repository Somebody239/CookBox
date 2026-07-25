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
    let hideFavourites: Bool

    init(searchText: Binding<String>, hideFavourites: Bool = false) {
        self._searchText = searchText
        self.hideFavourites = hideFavourites
    }

    var body: some View {
        ZStack {
            Color("AppBackground")
                .ignoresSafeArea()
            VStack() {
                ScrollView { //Recipies
                    LazyVStack(spacing: 14) {
                        ForEach(recipes) { recipe in
                            if (!hideFavourites || !recipe.isFavourite) &&
                                (recipe.name.localizedCaseInsensitiveContains(searchText) || searchText.isEmpty) {
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
        HStack(spacing: 16) {
            if let imageData = recipe.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 130, height: 120)
                    .clipped()
            }

            Text(recipe.name)
                .font(.headline)

            Spacer()

            Image(systemName: "chevron.right")
                .padding(.trailing, 16)
        }
        .frame(maxWidth: .infinity, minHeight: 120, maxHeight: 120, alignment: .leading)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 30))
    }
}


#Preview {
    SearchView(searchText: .constant(""))
        .modelContainer(for: Recipe.self, inMemory: true)
}
