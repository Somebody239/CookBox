//
//  AddRecipeView.swift
//  CookBox
//
//  Created by Kishan on 2026-07-14.
//

import SwiftUI
import PhotosUI
import SwiftData

@available(iOS 26.0, *)
struct AddRecipeView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var recipeName = ""
    @State private var recipeDescription = ""
    @State private var ingredients: [Ingredient] = [Ingredient()]
    @State private var steps: [CookingStep] = [CookingStep()]

    @State private var prepTimeMinutes = 0
    @State private var cookingTimeMinutes = 0
    @State private var servings = 1

    @State private var dishType = "Main Dish"
    @State private var cuisine = ""
    @State private var difficulty = "Easy"
    @State private var tags = ""

    @State private var notes = ""
    @State private var sourceName = ""
    @State private var sourceURL = ""

    @State private var calories = ""
    @State private var protein = ""
    @State private var carbohydrates = ""
    @State private var fat = ""
    @State private var fibre = ""

    @State private var isFavourite = false


    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil

    @Environment(\.modelContext) private var context

    private let dishTypes = [
        "Breakfast",
        "Lunch",
        "Dinner",
        "Appetizer",
        "Main Dish",
        "Side Dish",
        "Dessert",
        "Snack",
        "Drink"
    ]

    private let difficultyLevels = ["Easy", "Medium", "Hard"]

    var body: some View {
        ZStack {
            Color("AppBackground")
                .ignoresSafeArea()

            NavigationStack() {
                Form() {
                    Section("Photo") {
                        VStack(spacing: 16) {
                            if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: 340, minHeight: 250, maxHeight: 250)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            } else {
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 250)
                                    .overlay(
                                        Label("Select Photo", systemImage: "photo.badge.plus")
                                            .foregroundColor(.gray)
                                    )
                            }

                            PhotosPicker(selection: $selectedItem, matching: .images) {
                                Text("Choose from Gallery")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.accentColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(25)
                            }
                            .buttonStyle(.plain)
                            .glassEffect()
                            .onChange(of: selectedItem) { _, newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        selectedImageData = data
                                    }
                                }
                            }
                        }

                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.clear)
                                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
                        )
                    }


                    Section("Recipe") {
                        VStack(spacing: 15) {
                            TextField("Recipe name", text: $recipeName)
                                .listRowBackground(
                                    Rectangle()
                                        .fill(Color.clear)
                                        .glassEffect()
                                )
                            
                            Divider()
                            
                            TextField("Description", text: $recipeDescription, axis: .vertical)
                                .lineLimit(3...6)
                                
                        }
                        .listRowBackground(
                            Rectangle()
                                .fill(Color.clear)
                                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 32))
                        )
                    }
                    

                    Section("Ingredients") {
                        VStack(spacing: 0) {
                            ForEach($ingredients) { $ingredient in
                                HStack {
                                    TextField("Ingredient", text: $ingredient.name)
                                    Spacer()
                                    TextField("Amount", text: $ingredient.measurement)
                                        .multilineTextAlignment(.trailing)
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical, 12)

                                Divider()
                            }
                            .onDelete { indexSet in
                                ingredients.remove(atOffsets: indexSet)
                            }

                            Button {
                                ingredients.append(Ingredient())
                            } label: {
                                Label("Add Ingredient", systemImage: "plus.circle")
                            }
                            .padding(.vertical, 12)
                        }
                        .listRowInsets(EdgeInsets())
                        .padding(.horizontal, 18)
                        .padding(.vertical, 4)
                        .listRowBackground(
                            Color.clear
                                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
                        )
                    }

                    Section("Steps") {
                        VStack(spacing: 0) {
                            ForEach($steps) { $step in
                                HStack() {
                                    Text("\(step.stepNumber)")
                                        .foregroundColor(.gray)
                                        .frame(width: 15)

                                    TextField("Describe this step", text: $step.instruction)
                                        .lineLimit(2...6)
                                        
                                }
                                .padding(.vertical, 12)

                                Divider()
                            }
                            .onDelete { indexSet in
                                steps.remove(atOffsets: indexSet)

                                for index in steps.indices {
                                    steps[index].stepNumber = index + 1
                                }
                            }

                            Button {
                                steps.append(CookingStep(stepNumber: steps.count + 1))
                            } label: {
                                Label("Add Step", systemImage: "plus.circle")
                            }
                            .padding(.vertical, 12)
                        }
                        .listRowInsets(EdgeInsets())
                        .padding(.horizontal, 18)
                        .padding(.vertical, 4)
                        .listRowBackground(
                            Color.clear
                                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
                        )
                    }

                    Section("Time and Servings") {
                        VStack(spacing: 0) {
                            Stepper(value: $prepTimeMinutes, in: 0...1440, step: 5) {
                                HStack {
                                    Text("Preparation time")
                                    Spacer()
                                    Text("\(prepTimeMinutes) min")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 12)

                            Divider()

                            Stepper(value: $cookingTimeMinutes, in: 0...1440, step: 5) {
                                HStack {
                                    Text("Cooking time")
                                    Spacer()
                                    Text("\(cookingTimeMinutes) min")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 12)
                            

                            Divider()

                            Stepper(value: $servings, in: 1...50) {
                                HStack {
                                    Text("Servings")
                                    Spacer()
                                    Text("\(servings)")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 12)
                        }
                        .listRowInsets(EdgeInsets())
                        .padding(.horizontal, 18)
                        .padding(.vertical, 4)
                        .listRowBackground(
                            Color.clear
                                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
                        )
                    }

                    Section("Details") {
                        VStack(spacing: 0) {
                            Picker("Dish type", selection: $dishType) {
                                ForEach(dishTypes, id: \.self) { type in
                                    Text(type)
                                        .tag(type)
                                }
                            }
                            .pickerStyle(.menu)
                            .padding(.vertical, 12)

                            Divider()

                            HStack {
                                Text("Cuisine")
                                Spacer()
                                TextField("Italian", text: $cuisine)
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 12)

                            Divider()

                            Picker("Difficulty", selection: $difficulty) {
                                ForEach(difficultyLevels, id: \.self) { level in
                                    Text(level)
                                        .tag(level)
                                }
                            }
                            .pickerStyle(.menu)
                            .padding(.vertical, 12)

                            Divider()

                            HStack {
                                Text("Tags")
                                Spacer()
                                TextField("Quick, healthy", text: $tags)
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 12)
                        }
                        .listRowInsets(EdgeInsets())
                        .padding(.horizontal, 18)
                        .padding(.vertical, 4)
                        .listRowBackground(
                            Color.clear
                                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
                        )
                    }

                    Section("Nutrition") {
                        VStack(spacing: 0) {
                            HStack {
                                Text("Calories")
                                Spacer()
                                TextField("kcal", text: $calories)
                                    .keyboardType(.numberPad)
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 12)

                            Divider()

                            HStack {
                                Text("Protein")
                                Spacer()
                                TextField("g", text: $protein)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 12)

                            Divider()

                            HStack {
                                Text("Carbohydrates")
                                Spacer()
                                TextField("g", text: $carbohydrates)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 12)

                            Divider()

                            HStack {
                                Text("Fat")
                                Spacer()
                                TextField("g", text: $fat)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 12)

                            Divider()

                            HStack {
                                Text("Fibre")
                                Spacer()
                                TextField("g", text: $fibre)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 12)
                        }
                        .listRowInsets(EdgeInsets())
                        .padding(.horizontal, 18)
                        .padding(.vertical, 4)
                        .listRowBackground(
                            Color.clear
                                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
                        )
                    }

                    Section("Notes") {
                        TextField("Add any extra notes", text: $notes, axis: .vertical)
                            .lineLimit(3...6)
                            .listRowBackground(
                                Rectangle()
                                    .fill(Color.clear)
                                    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
                            )
                    }

                    Section("Source") {
                        VStack(spacing: 0) {
                            TextField("Source name", text: $sourceName)
                                .padding(.vertical, 12)

                            Divider()

                            TextField("Website link", text: $sourceURL)
                                .keyboardType(.URL)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .padding(.vertical, 12)
                        }
                        .listRowInsets(EdgeInsets())
                        .padding(.horizontal, 18)
                        .padding(.vertical, 4)
                        .listRowBackground(
                            Color.clear
                                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
                        )
                    }

                    Section {
                        Toggle("Add to Favourites", isOn: $isFavourite)
                            .listRowBackground(
                                Rectangle()
                                    .fill(Color.clear)
                                    .glassEffect()
                            )
                    }





                }
                .scrollContentBackground(.hidden)
                .background(Color("AppBackground"))
                .navigationTitle(recipeName.isEmpty ? "New Recipe" : recipeName) // Tittle of Navigation stack, hidden away
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }

                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            let savedIngredients = ingredients.filter {
                                !$0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                                !$0.measurement.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                            }

                            let savedSteps = steps
                                .filter {
                                    !$0.instruction.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                }
                                .enumerated()
                                .map { index, step in
                                    CookingStep(
                                        id: step.id,
                                        stepNumber: index + 1,
                                        instruction: step.instruction
                                    )
                                }

                            let savedTags = tags
                                .split(separator: ",")
                                .map {
                                    $0.trimmingCharacters(in: .whitespacesAndNewlines)
                                }
                                .filter {
                                    !$0.isEmpty
                                }

                            let hasNutritionInformation = [calories, protein, carbohydrates, fat, fibre]
                                .contains {
                                    !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                }

                            let savedNutrition = hasNutritionInformation
                                ? NutritionInfo(
                                    calories: Int(calories) ?? 0,
                                    protein: Double(protein) ?? 0,
                                    carbohydrates: Double(carbohydrates) ?? 0,
                                    fat: Double(fat) ?? 0,
                                    fibre: Double(fibre) ?? 0
                                )
                                : nil

                            let newRecipe = Recipe(
                                imageData: selectedImageData,
                                name: recipeName,
                                recipeDescription: recipeDescription,
                                ingredients: savedIngredients,
                                steps: savedSteps,
                                prepTimeMinutes: prepTimeMinutes,
                                cookingTimeMinutes: cookingTimeMinutes,
                                servings: servings,
                                dishType: dishType,
                                cuisine: cuisine,
                                difficulty: difficulty,
                                tags: savedTags,
                                notes: notes,
                                sourceName: sourceName,
                                sourceURL: sourceURL,
                                nutritionInfo: savedNutrition,
                                isFavourite: isFavourite
                            )
                            context.insert(newRecipe)

                            dismiss()

                        }
                        .disabled(recipeName.isEmpty)
                    }
                }




            }

        }

    }
}

#Preview {
    AddRecipeView()
        .modelContainer(for: Recipe.self, inMemory: true)
}
