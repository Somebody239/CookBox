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
    @State private var ingredients: [Ingredient] = [Ingredient()]


    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: Image? = nil

    @Environment(\.modelContext) private var context

    var body: some View {
        ZStack {
            Color("AppBackground")
                .ignoresSafeArea()

            NavigationStack() {
                Form() {
                    Section("Photo") {
                        VStack(spacing: 16) {
                            if let selectedImage {
                                selectedImage
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
                                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                                       let uiImage = UIImage(data: data) {
                                        selectedImage = Image(uiImage: uiImage)
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
                        TextField("Recipe name", text: $recipeName)
                            .listRowBackground(
                                Rectangle()
                                    .fill(Color.clear)
                                    .glassEffect()
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





                }
                .scrollContentBackground(.hidden)
                .background(Color("AppBackground"))
                .navigationTitle("New Recipe")
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
                            let newRecipe = Recipe(recipeName: recipeName, ingredients: savedIngredients)
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
