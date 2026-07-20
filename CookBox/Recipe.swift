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
    @Attribute(.externalStorage) var imageData: Data?
    var name: String
    var ingredients: [Ingredient]

    init(imageData: Data? = nil, name: String, ingredients: [Ingredient] = []) {
        self.imageData = imageData
        self.name = name
        self.ingredients = ingredients
    }
}
