//
//  Recipe.swift
//  CookBox
//
//  Created by Kishan on 2026-07-15.
//

import Foundation
import SwiftData


struct Ingredient: Identifiable, Codable {
    var id = UUID()
    var name: String = ""
    var measurement: String = ""
}


struct CookingStep: Identifiable, Codable {
    var id = UUID()
    var stepNumber: Int = 1
    var instruction: String = ""
}


struct NutritionInfo: Codable {
    var calories: Int = 0
    var protein: Double = 0
    var carbohydrates: Double = 0
    var fat: Double = 0
    var fibre: Double = 0
}


@Model
class Recipe {
    @Attribute(.externalStorage)
    var imageData: Data?

    var name: String
    var recipeDescription: String

    var ingredients: [Ingredient]
    var steps: [CookingStep]

    var prepTimeMinutes: Int
    var cookingTimeMinutes: Int
    var servings: Int

    var dishType: String
    var cuisine: String
    var difficulty: String
    var tags: [String]

    var notes: String
    var sourceName: String
    var sourceURL: String

    var nutritionInfo: NutritionInfo?

    var isFavourite: Bool
    var dateCreated: Date
    var dateUpdated: Date


    init(
        imageData: Data? = nil,
        name: String,
        recipeDescription: String = "",
        ingredients: [Ingredient] = [],
        steps: [CookingStep] = [],
        prepTimeMinutes: Int = 0,
        cookingTimeMinutes: Int = 0,
        servings: Int = 1,
        dishType: String = "",
        cuisine: String = "",
        difficulty: String = "",
        tags: [String] = [],
        notes: String = "",
        sourceName: String = "",
        sourceURL: String = "",
        nutritionInfo: NutritionInfo? = nil,
        isFavourite: Bool = false,
        dateCreated: Date = Date(),
        dateUpdated: Date = Date()
    ) {
        self.imageData = imageData
        self.name = name
        self.recipeDescription = recipeDescription
        self.ingredients = ingredients
        self.steps = steps
        self.prepTimeMinutes = prepTimeMinutes
        self.cookingTimeMinutes = cookingTimeMinutes
        self.servings = servings
        self.dishType = dishType
        self.cuisine = cuisine
        self.difficulty = difficulty
        self.tags = tags
        self.notes = notes
        self.sourceName = sourceName
        self.sourceURL = sourceURL
        self.nutritionInfo = nutritionInfo
        self.isFavourite = isFavourite
        self.dateCreated = dateCreated
        self.dateUpdated = dateUpdated
    }


    var totalTimeMinutes: Int {
        prepTimeMinutes + cookingTimeMinutes
    }
}
