// MockDataLoader.swift
// SwiftBites
//
// Created by Alex Rublov on 23/11/2025.
// Copyright © 2025 Alex Rublov. All rights reserved.
//
// ========================================================

import Foundation
import SwiftUI
import SwiftData

struct MockDataLoader {
    
    // Inject Storage explicitly; do not use @Environment here
//    let storage: Storage
//    
//    init(storage: Storage) {
//        self.storage = storage
//    }
//    
//    // Convenience overload that uses injected storage
//    func importMockData(context: ModelContext) async {
//        await importMockData(context: context, storage: storage)
//    }
//    
//    func importMockData(context: ModelContext, storage: Storage) async {
//        print("importMockData started!!!")
//        // If there are already recipes, exit.
//        let existing = try? context.fetch(FetchDescriptor<Recipe>())
//        if (existing?.isEmpty == false) { return }
//        
//        let mockCategories: [MockCategory] = storage.categories
//        let mockIngredients: [MockIngredient] = storage.ingredients
//        
//        // Ensure storage is populated; if empty, do nothing
//        guard !(mockCategories.isEmpty && mockIngredients.isEmpty) else {
//            return
//        }
//        
//        // Caches to avoid creating duplicates
//        var categoryCache: [String: Category] = [:]
//        var ingredientCache: [String: Ingredient] = [:]
//        
//        
//        // 1. Create import loop for Categories
//        /// The main import cycle for mock categories and their recipes
//        for mockCategory in mockCategories {
//            let cat = category(for: mockCategory.name)
//            for mockRecipe in mockCategory.recipes {
//                _ = await createRecipe(from: mockRecipe, in: cat)
//            }
//        }
//        
//        // 2. Create import loop for Ingredient
//        for mockIngr in mockIngredients {
//            _ = ingredient(for: mockIngr.name)
//        }
//        
//        try? context.save()
//        
//        // Category factory without recursion
//        func category(for name: String) -> Category {
//            if let cached = categoryCache[name] {
//                return cached
//            }
//            // Попробуем найти в базе (на случай повторного запуска импорта)
//            if let existing = try? context.fetch(
//                FetchDescriptor<Category>(predicate: #Predicate { $0.name == name })
//            ).first {
//                categoryCache[name] = existing
//                return existing
//            }
//            let new = Category(name: name)
//            context.insert(new)
//            categoryCache[name] = new
//            return new
//        }
//        
//        // Ingredient Factory
//        func ingredient(for name: String) -> Ingredient {
//            if let cached = ingredientCache[name] {
//                return cached
//            }
//            if let existing = try? context.fetch(
//                FetchDescriptor<Ingredient>(predicate: #Predicate { $0.name == name })
//            ).first {
//                ingredientCache[name] = existing
//                return existing
//            }
//            let new = Ingredient(name: name)
//            context.insert(new)
//            ingredientCache[name] = new
//            return new
//        }
//        
//        // Mapping MockRecipeIngredient → RecipeIngredient (requires a ready Recipe)
//        func mapRecipeIngredients(from mockItems: [MockRecipeIngredient], for recipe: Recipe) -> [RecipeIngredient] {
//            mockItems.map { m in
//                let ing = ingredient(for: m.ingredient.name)
//                return RecipeIngredient(ingredient: ing, recipe: recipe, quantity: m.quantity)
//            }
//        }
//        
//        // Create a Recipe with a Category binding
//        func createRecipe(from mockRecipe: MockRecipe, in category: Category?) async -> Recipe {
//            // Convert imageData (if in mocks Data?) to a file name string
//            let imageFileName: String? = await saveMockImage(mockRecipe.imageData)
//            
//            // First we create a recipe without ingredients to have an instance for relationships
//            let recipe = Recipe(
//                name: mockRecipe.name,
//                summary: mockRecipe.summary,
//                category: category,
//                serving: mockRecipe.serving,
//                time: mockRecipe.time,
//                ingredients: [],
//                instructions: mockRecipe.instructions,
//                imageData: imageFileName
//            )
//            context.insert(recipe)
//            
//            // Now we create associated RecipeIngredient with a specific recipe instance
//            let ingredients = mapRecipeIngredients(from: mockRecipe.ingredients, for: recipe)
//            recipe.ingredients = ingredients
//            return recipe
//        }
//        
//        // Image saving function
//        func saveMockImage(_ data: Data?) async -> String? {
//            guard let data else { return nil }
//            let fileName = try? await ImageStorage.shared.save(imageData: data, id: UUID())
//            return fileName
//        }
//    }
}
