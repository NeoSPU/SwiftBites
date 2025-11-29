// Ingradient.swift
// SwiftBites
//
// Created by Alex Rublov on 22/11/2025.
// Copyright © 2025 Alex Rublov. All rights reserved.
//
// ========================================================

import Foundation
import SwiftData

@Model
final class RecipeIngredient {
    @Attribute(.unique) var id: UUID
    
    // Ingredient is global
    @Relationship(deleteRule: .nullify)
    var ingredient: Ingredient
    
    // parent Recipe, deleteRule is cascade delete all children
    @Relationship(deleteRule: .cascade, inverse: \Recipe.ingredients)
    var recipe: Recipe?
    
    var quantity: String

    init(id: UUID = UUID(), ingredient: Ingredient, recipe: Recipe, quantity: String = "") {
        self.id = id
        self.ingredient = ingredient
        self.recipe = recipe
        self.quantity = quantity
    }
}
