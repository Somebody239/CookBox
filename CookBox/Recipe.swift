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

@Model
class Recipe {
    var recipeName: String
    var ingredients: [Ingredient]

    init(recipeName: String, ingredients: [Ingredient] = []) {
        self.recipeName = recipeName
        self.ingredients = ingredients
    }
}
