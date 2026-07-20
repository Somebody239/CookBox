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
                                    featured(for: recipe)
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
            if let imageData = recipe.imageData, let uiImage = UIImage(data: imageData) {
                ZStack() {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 325, height: 175)
                    
                    Text(recipe.name)
                        .font(.title2)
                        .bold()
                        .padding(.bottom, 10)
                        .padding(.leading, 5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
                
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
