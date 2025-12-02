// PersistenceService.swift
// SwiftBites
//
// Created by Alex Rublov on 30/11/2025.
// Copyright © 2025 Alex Rublov. All rights reserved.
//
// ========================================================

import SwiftData
import SwiftUI

enum PersistenceError: Error, LocalizedError {
    case categoryAlreadyExists(name: String)
    case categoryNotFound(name: String)
    case ingredientAlreadyExists(name: String)
    case ingredientNotFound(name: String)
    case recipeAlreadyExists(name: String)
    case recipeNotFound(name: String)
    
    var errorDescription: String? {
        switch self {
        case .categoryAlreadyExists(let name):
            return "Category with name \"\(name)\" already exists."
        case .categoryNotFound(let name):
            return "Category with name \"\(name)\" was not found."
        case .ingredientAlreadyExists(let name):
            return "Ingredient with name \"\(name)\" already exists."
        case .ingredientNotFound(let name):
            return "Ingredient with name \"\(name)\" was not found."
        case .recipeAlreadyExists(let name):
            return "Recipe with name \"\(name)\" already exists."
        case .recipeNotFound(let name):
            return "Recipe with name \"\(name)\" was not found."
        }
    }
}

final class PersistenceService {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    //MARK: CRUD methods for Category
    /// Creation method for Category
    @discardableResult
    func addCategory(name: String) throws -> Category {
        let descriptor = FetchDescriptor<Category>(
            predicate: #Predicate { $0.name == name }
        )
        let existing = try modelContext.fetch(descriptor)
        if existing.first != nil {
            throw PersistenceError.categoryAlreadyExists(name: name)
        }
        let newCategory = Category(name: name)
        modelContext.insert(newCategory)
        try modelContext.save()
        return newCategory
    }
    
    /// Read method for Category
    func fetchCategory(named name: String) throws -> Category {
        let descriptor = FetchDescriptor<Category>(
            predicate: #Predicate { $0.name == name }
        )
        let results = try modelContext.fetch(descriptor)
        if let category = results.first {
            return category
        } else {
            throw PersistenceError.categoryNotFound(name: name)
        }
    }
    
    /// Update method for Category
    @discardableResult
    func updateCategory(name: String) throws -> Category {
        let descriptor = FetchDescriptor<Category>(
            predicate: #Predicate { $0.name == name }
        )
        guard let category = try modelContext.fetch(descriptor).first else {
            throw PersistenceError.categoryNotFound(name: name)
        }
        return category
    }
    
    /// Delete method for Category
    @discardableResult
    func deleteCategory(name: String) throws -> Bool {
        let descriptor = FetchDescriptor<Category>(
            predicate: #Predicate { $0.name == name }
        )
        if let category = try modelContext.fetch(descriptor).first {
            modelContext.delete(category)
            try modelContext.save()
            return true
        } else {
            throw PersistenceError.categoryNotFound(name: name)
        }
    }
    
    //MARK: CRUD methods for Ingredient
    /// Creation method for Ingredient
    @discardableResult
    func addIngredient(name: String) throws -> Ingredient {
        let descriptor = FetchDescriptor<Ingredient>(
            predicate: #Predicate { $0.name == name }
        )
        let existing = try modelContext.fetch(descriptor)
        if existing.first != nil {
            throw PersistenceError.ingredientAlreadyExists(name: name)
        }
        let newIngredient = Ingredient(name: name)
        modelContext.insert(newIngredient)
        try modelContext.save()
        return newIngredient
    }
    
    /// Read method for Ingredient
    func fetchIngredient(named name: String) throws -> Ingredient {
        let descriptor = FetchDescriptor<Ingredient>(
            predicate: #Predicate { $0.name == name }
        )
        let results = try modelContext.fetch(descriptor)
        if let ingredient = results.first {
            return ingredient
        } else {
            throw PersistenceError.ingredientNotFound(name: name)
        }
    }
    
    /// Update method for Ingredient
    @discardableResult
    func updateIngredient(name: String) throws -> Ingredient {
        let descriptor = FetchDescriptor<Ingredient>(
            predicate: #Predicate { $0.name == name }
        )
        guard let ingredient = try modelContext.fetch(descriptor).first else {
            throw PersistenceError.ingredientNotFound(name: name)
        }
        return ingredient
    }
    
    /// Delete method for Ingredient
    @discardableResult
    func deleteIngredient(name: String) throws -> Bool {
        let descriptor = FetchDescriptor<Ingredient>(
            predicate: #Predicate { $0.name == name }
        )
        if let ingredient = try modelContext.fetch(descriptor).first {
            modelContext.delete(ingredient)
            try modelContext.save()
            return true
        } else {
            throw PersistenceError.ingredientNotFound(name: name)
        }
    }

    
    //MARK: CRUD methods for Reciep
    /// Creation method for Recipe
    @discardableResult
    func addRecipe(name: String,
                   summary: String = "",
                   category: Category? = nil,
                   serving: Int = 1,
                   time: Int = 5,
                   ingredients: [RecipeIngredient] = [],
                   instructions: String = "",
                   imageData: Data? = nil) async throws -> Recipe {
        let descriptor = FetchDescriptor<Recipe>(
            predicate: #Predicate { $0.name == name }
        )
        let existing = try modelContext.fetch(descriptor)
        if existing.first != nil {
            throw PersistenceError.recipeAlreadyExists(name: name)
        }

        let imageFileName: String? = try? await ImageStorage.shared.save(imageData: imageData, id: UUID())

        let newRecipe = Recipe(
            name: name,
            summary: summary,
            category: category,
            serving: serving,
            time: time,
            ingredients: [],
            instructions: instructions,
            imageData: imageFileName
        )
        modelContext.insert(newRecipe)
        try modelContext.save()

        if !ingredients.isEmpty {
            let bound = ingredients.map { item in
                if item.recipe === newRecipe { return item }
                return RecipeIngredient(ingredient: item.ingredient, recipe: newRecipe, quantity: item.quantity)
            }
            newRecipe.ingredients = bound
        }

        return newRecipe
    }
    
    /// Read method for Recipe
    func fetchRecipe(named name: String) throws -> Recipe {
        let descriptor = FetchDescriptor<Recipe>(
            predicate: #Predicate { $0.name == name }
        )
        let results = try modelContext.fetch(descriptor)
        if let recipe = results.first {
            return recipe
        } else {
            throw PersistenceError.recipeNotFound(name: name)
        }
    }
    
    /// Update method for Recipe
    @discardableResult
    func updateRecipe(id: Recipe.ID,
                      name: String,
                      summary: String = "",
                      category: Category? = nil,
                      serving: Int = 1,
                      time: Int = 5,
                      ingredients: [RecipeIngredient] = [],
                      instructions: String = "",
                      imageData: Data? = nil) async throws -> Recipe {
        let descriptor = FetchDescriptor<Recipe>(
            predicate: #Predicate { $0.id == id }
        )
        guard let recipe = try modelContext.fetch(descriptor).first else {
            throw PersistenceError.recipeNotFound(name: name)
        }

        let dupDescriptor = FetchDescriptor<Recipe>(
            predicate: #Predicate { $0.name == name && $0.id != id }
        )
        if let _ = try modelContext.fetch(dupDescriptor).first {
            throw PersistenceError.recipeAlreadyExists(name: name)
        }

        recipe.name = name
        recipe.summary = summary
        recipe.category = category
        recipe.serving = serving
        recipe.time = time
        recipe.instructions = instructions

        if let imageData {
            let imageFileName = try? await ImageStorage.shared.save(imageData: imageData, id: UUID())
            recipe.imageData = imageFileName
        }

        let rebuilt = ingredients.map { item in
            if item.recipe === recipe { return item }
            return RecipeIngredient(ingredient: item.ingredient, recipe: recipe, quantity: item.quantity)
        }
        recipe.ingredients = rebuilt

        try modelContext.save()
        return recipe
    }
    
    /// Delete method for Recipe
    @discardableResult
    func delete(_ recipe: Recipe) throws -> Bool {
        modelContext.delete(recipe)
        try modelContext.save()
        return true
    }
    
    @discardableResult
    func deleteRecipe(name: String) throws -> Bool {
        let descriptor = FetchDescriptor<Recipe>(
            predicate: #Predicate { $0.name == name }
        )
        if let recipe = try modelContext.fetch(descriptor).first {
            modelContext.delete(recipe)
            try modelContext.save()
            return true
        } else {
            throw PersistenceError.recipeNotFound(name: name)
        }
    }

}
