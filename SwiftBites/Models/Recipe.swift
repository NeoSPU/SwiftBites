// Recipe.swift
// SwiftBites
//
// Created by Alex Rublov on 22/11/2025.
// Copyright © 2025 Alex Rublov. All rights reserved.
//
// ========================================================

import Foundation
import SwiftData

@Model
final class Recipe {
    @Attribute(.unique) var id: UUID
    var name: String
    var summary: String
    var serving: Int
    var time: Int
    var instructions: String
    // store filename; image saved externally
    var imageData: String?
    
    // relationships
    var category: Category?
    var ingredients: [RecipeIngredient] = []
    
    init(
      id: UUID = UUID(),
      name: String = "",
      summary: String = "",
      category: Category? = nil,
      serving: Int = 1,
      time: Int = 5,
      ingredients: [RecipeIngredient] = [],
      instructions: String = "",
      imageData: String? = nil
    ) {
      self.id = id
      self.name = name
      self.summary = summary
      self.category = category
      self.serving = serving
      self.time = time
      self.ingredients = ingredients
      self.instructions = instructions
      self.imageData = imageData
    }
}

