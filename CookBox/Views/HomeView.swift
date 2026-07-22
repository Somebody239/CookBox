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
    @State private var searchText = ""
    @State private var showingSheet = false
    let today = Date.now

    @Query private var recipes: [Recipe]
    @Environment(\.modelContext) private var context
    
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
                        
                        ScrollView(.horizontal) {
                            HStack() {
                                ForEach(recipes) { recipe in
                                    NavigationLink {
                                        RecipeView(recipe: recipe)
                                    } label: {
                                        featured(for: recipe)
                                    }
                                    .buttonStyle(.plain)
                                }
                                // .padding(.trailing, 10)    Do i add this??
                                
                            }
                            .padding(.leading, 25)
                        }
                        
                        
                        SearchView(searchText: $searchText)
                        
                        
                    
                    
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
            .task {
                if recipes.isEmpty {
                    let mockImage = UIImage(named: "LaunchLogo")
                    let mockImageData = mockImage?.pngData()
                    
                    context.insert(Recipe(imageData: mockImageData, name: "Creamy Tomato Pasta"))
                    context.insert(Recipe(imageData: mockImageData, name: "Chicken Tacos"))
                    context.insert(Recipe(imageData: mockImageData, name: "Blueberry Pancakes"))
                }
            }
        }
    }
    private func featured(for recipe: Recipe) -> some View {
        HStack {
            ZStack() {
                if let imageData = recipe.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 325, height: 175)
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 325, height: 175)

                    Image(systemName: "fork.knife")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }

                Text(recipe.name)
                    .font(.title2)
                    .bold()
                    .padding(.bottom, 10)
                    .padding(.leading, 5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
        .padding()
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 30))
        .cornerRadius(12)
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Recipe.self, inMemory: true)
}
