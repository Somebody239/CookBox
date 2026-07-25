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

                        Text("Favourites")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.leading, 25)
                            .padding(.top, 1)
                        
                        ScrollView(.horizontal) {
                            HStack() {
                                ForEach(favouriteRecipes) { recipe in
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

                        Text("More Recipes")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.leading, 25)
                            .padding(.top, 30)
                        
                        
                        SearchView(searchText: $searchText, hideFavourites: true)
                            .padding(.top, -10)
                        
                    
                    
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
                let demoRecipes = [
                    Recipe(
                        imageData: UIImage(named: "Pasta")?.pngData(),
                        name: "Creamy Tomato Pasta",
                        recipeDescription: "A simple tomato pasta with a silky cream sauce.",
                        ingredients: [
                            Ingredient(name: "Pasta", measurement: "2 cups"),
                            Ingredient(name: "Tomato sauce", measurement: "1 1/2 cups"),
                            Ingredient(name: "Cream", measurement: "1/2 cup"),
                            Ingredient(name: "Parmesan", measurement: "1/3 cup")
                        ],
                        steps: [
                            CookingStep(stepNumber: 1, instruction: "Boil the pasta until tender."),
                            CookingStep(stepNumber: 2, instruction: "Warm the tomato sauce in a pan."),
                            CookingStep(stepNumber: 3, instruction: "Stir in the cream and Parmesan."),
                            CookingStep(stepNumber: 4, instruction: "Combine the pasta and sauce, then serve.")
                        ],
                        prepTimeMinutes: 10,
                        cookingTimeMinutes: 20,
                        servings: 4,
                        dishType: "Main Dish",
                        cuisine: "Italian",
                        difficulty: "Easy",
                        tags: ["Comfort Food", "Quick"],
                        notes: "Save a little pasta water in case the sauce needs thinning.",
                        sourceName: "CookBox Sample",
                        nutritionInfo: NutritionInfo(
                            calories: 520,
                            protein: 18,
                            carbohydrates: 72,
                            fat: 19,
                            fibre: 5
                        ),
                        isFavourite: true
                    ),
                    Recipe(
                        imageData: UIImage(named: "Tacos")?.pngData(),
                        name: "Chicken Tacos",
                        recipeDescription: "Seasoned chicken tacos with fresh toppings and lime.",
                        ingredients: [
                            Ingredient(name: "Chicken breast", measurement: "1 lb"),
                            Ingredient(name: "Taco seasoning", measurement: "2 tbsp"),
                            Ingredient(name: "Small tortillas", measurement: "8"),
                            Ingredient(name: "Shredded lettuce", measurement: "1 cup"),
                            Ingredient(name: "Diced tomatoes", measurement: "1 cup")
                        ],
                        steps: [
                            CookingStep(stepNumber: 1, instruction: "Coat the chicken with taco seasoning."),
                            CookingStep(stepNumber: 2, instruction: "Cook the chicken until browned and fully cooked."),
                            CookingStep(stepNumber: 3, instruction: "Slice the chicken and warm the tortillas."),
                            CookingStep(stepNumber: 4, instruction: "Fill each tortilla and add the toppings.")
                        ],
                        prepTimeMinutes: 15,
                        cookingTimeMinutes: 20,
                        servings: 4,
                        dishType: "Dinner",
                        cuisine: "Mexican",
                        difficulty: "Easy",
                        tags: ["Family Dinner", "Fresh"],
                        notes: "Serve with lime wedges and your favourite salsa.",
                        sourceName: "CookBox Sample",
                        nutritionInfo: NutritionInfo(
                            calories: 410,
                            protein: 34,
                            carbohydrates: 38,
                            fat: 14,
                            fibre: 4
                        ),
                        isFavourite: true
                    ),
                    Recipe(
                        imageData: UIImage(named: "Blueberry Pancakes")?.pngData(),
                        name: "Blueberry Pancakes",
                        recipeDescription: "Soft, fluffy pancakes filled with juicy blueberries.",
                        ingredients: [
                            Ingredient(name: "Flour", measurement: "1 1/2 cups"),
                            Ingredient(name: "Baking powder", measurement: "2 tsp"),
                            Ingredient(name: "Milk", measurement: "1 1/4 cups"),
                            Ingredient(name: "Egg", measurement: "1"),
                            Ingredient(name: "Blueberries", measurement: "1 cup")
                        ],
                        steps: [
                            CookingStep(stepNumber: 1, instruction: "Mix the flour and baking powder in a bowl."),
                            CookingStep(stepNumber: 2, instruction: "Whisk in the milk and egg until just combined."),
                            CookingStep(stepNumber: 3, instruction: "Fold the blueberries into the batter."),
                            CookingStep(stepNumber: 4, instruction: "Cook each pancake until golden on both sides.")
                        ],
                        prepTimeMinutes: 10,
                        cookingTimeMinutes: 15,
                        servings: 4,
                        dishType: "Breakfast",
                        cuisine: "American",
                        difficulty: "Easy",
                        tags: ["Breakfast", "Sweet"],
                        notes: "Do not overmix the batter or the pancakes may become dense.",
                        sourceName: "CookBox Sample",
                        nutritionInfo: NutritionInfo(
                            calories: 330,
                            protein: 9,
                            carbohydrates: 55,
                            fat: 8,
                            fibre: 3
                        )
                    ),
                    Recipe(
                        imageData: UIImage(named: "Pizza")?.pngData(),
                        name: "Margherita Pizza",
                        recipeDescription: "A homemade pizza with tomato sauce, mozzarella, and fresh basil.",
                        ingredients: [
                            Ingredient(name: "Pizza dough", measurement: "1 ball"),
                            Ingredient(name: "Tomato sauce", measurement: "1/2 cup"),
                            Ingredient(name: "Mozzarella", measurement: "2 cups"),
                            Ingredient(name: "Fresh basil", measurement: "8 leaves"),
                            Ingredient(name: "Olive oil", measurement: "1 tbsp")
                        ],
                        steps: [
                            CookingStep(stepNumber: 1, instruction: "Stretch the pizza dough onto a baking tray."),
                            CookingStep(stepNumber: 2, instruction: "Spread the tomato sauce over the dough."),
                            CookingStep(stepNumber: 3, instruction: "Add the mozzarella and bake until golden."),
                            CookingStep(stepNumber: 4, instruction: "Top with basil and olive oil before serving.")
                        ],
                        prepTimeMinutes: 15,
                        cookingTimeMinutes: 15,
                        servings: 4,
                        dishType: "Main Dish",
                        cuisine: "Italian",
                        difficulty: "Medium",
                        tags: ["Homemade", "Vegetarian"],
                        notes: "Let the dough rest at room temperature before stretching it.",
                        sourceName: "CookBox Sample",
                        nutritionInfo: NutritionInfo(
                            calories: 560,
                            protein: 22,
                            carbohydrates: 70,
                            fat: 20,
                            fibre: 4
                        ),
                        isFavourite: true
                    ),
                    Recipe(
                        imageData: UIImage(named: "Pie")?.pngData(),
                        name: "Classic Apple Pie",
                        recipeDescription: "A warm apple pie with cinnamon filling and a flaky crust.",
                        ingredients: [
                            Ingredient(name: "Apples", measurement: "6"),
                            Ingredient(name: "Pie crusts", measurement: "2"),
                            Ingredient(name: "Sugar", measurement: "3/4 cup"),
                            Ingredient(name: "Cinnamon", measurement: "1 tsp"),
                            Ingredient(name: "Butter", measurement: "2 tbsp")
                        ],
                        steps: [
                            CookingStep(stepNumber: 1, instruction: "Peel and slice the apples."),
                            CookingStep(stepNumber: 2, instruction: "Mix the apples with sugar and cinnamon."),
                            CookingStep(stepNumber: 3, instruction: "Fill the bottom crust and cover with the second crust."),
                            CookingStep(stepNumber: 4, instruction: "Bake until the crust is golden and the filling bubbles.")
                        ],
                        prepTimeMinutes: 25,
                        cookingTimeMinutes: 50,
                        servings: 8,
                        dishType: "Dessert",
                        cuisine: "American",
                        difficulty: "Medium",
                        tags: ["Baking", "Dessert"],
                        notes: "Allow the pie to cool before slicing so the filling can set.",
                        sourceName: "CookBox Sample",
                        nutritionInfo: NutritionInfo(
                            calories: 390,
                            protein: 4,
                            carbohydrates: 58,
                            fat: 17,
                            fibre: 4
                        )
                    ),
                    Recipe(
                        imageData: UIImage(named: "Sandwich")?.pngData(),
                        name: "Club Sandwich",
                        recipeDescription: "A toasted triple-layer sandwich with chicken, bacon, and fresh vegetables.",
                        ingredients: [
                            Ingredient(name: "Bread", measurement: "3 slices"),
                            Ingredient(name: "Cooked chicken", measurement: "6 oz"),
                            Ingredient(name: "Bacon", measurement: "3 strips"),
                            Ingredient(name: "Lettuce", measurement: "2 leaves"),
                            Ingredient(name: "Tomato", measurement: "3 slices")
                        ],
                        steps: [
                            CookingStep(stepNumber: 1, instruction: "Toast the bread and cook the bacon until crisp."),
                            CookingStep(stepNumber: 2, instruction: "Layer chicken, lettuce, and tomato on the first slice."),
                            CookingStep(stepNumber: 3, instruction: "Add the next slice, bacon, and the remaining toppings."),
                            CookingStep(stepNumber: 4, instruction: "Top with the final slice, cut, and serve.")
                        ],
                        prepTimeMinutes: 15,
                        cookingTimeMinutes: 10,
                        servings: 2,
                        dishType: "Lunch",
                        cuisine: "American",
                        difficulty: "Easy",
                        tags: ["Quick", "Lunch"],
                        notes: "Secure each half with a toothpick before cutting.",
                        sourceName: "CookBox Sample",
                        nutritionInfo: NutritionInfo(
                            calories: 620,
                            protein: 42,
                            carbohydrates: 48,
                            fat: 28,
                            fibre: 4
                        )
                    )
                ]

                for demoRecipe in demoRecipes {
                    if !recipes.contains(where: { $0.name == demoRecipe.name }) {
                        context.insert(demoRecipe)
                    }
                }
            }
        }
    }

    private var favouriteRecipes: [Recipe] {
        recipes.filter { $0.isFavourite }
    }

    private func featured(for recipe: Recipe) -> some View {
        ZStack {
            if let imageData = recipe.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 325, height: 175)
                    .clipped()
            } else {
                Color.gray.opacity(0.2)

                Image(systemName: "fork.knife")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }

            Color.black.opacity(0.35)

            Text(recipe.name)
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .padding(16)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .frame(width: 325, height: 175)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 30))
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Recipe.self, inMemory: true)
}
