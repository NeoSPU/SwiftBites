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
    
    @Environment(\.storage) private var storage
    
    func importMockData(context: ModelContext) {
        // Если рецепты уже есть — выходим
        let existing = try? context.fetch(FetchDescriptor<Recipe>())
        if (existing?.isEmpty == false) { return }
        
        let mockCategories: [MockCategory] = storage.categories
        // при необходимости:
        // let mockIngredients: [MockIngredient] = storage.ingredients
        // let mockRecipes: [MockRecipe] = storage.recipes
        
        // Кеши, чтобы не создавать дубликаты
        var categoryCache: [String: Category] = [:]
        var ingredientCache: [String: Ingredient] = [:]
        
        // Фабрика Category без рекурсий
        func category(for name: String) -> Category {
            if let cached = categoryCache[name] {
                return cached
            }
            // Попробуем найти в базе (на случай повторного запуска импорта)
            if let existing = try? context.fetch(
                FetchDescriptor<Category>(predicate: #Predicate { $0.name == name })
            ).first {
                categoryCache[name] = existing
                return existing
            }
            let new = Category(name: name)
            context.insert(new)
            categoryCache[name] = new
            return new
        }
        
        // Фабрика Ingredient
        func ingredient(for name: String) -> Ingredient {
            if let cached = ingredientCache[name] {
                return cached
            }
            if let existing = try? context.fetch(
                FetchDescriptor<Ingredient>(predicate: #Predicate { $0.name == name })
            ).first {
                ingredientCache[name] = existing
                return existing
            }
            let new = Ingredient(name: name)
            context.insert(new)
            ingredientCache[name] = new
            return new
        }
//        
//        // Маппинг MockRecipeIngredient → RecipeIngredient
//        func mapRecipeIngredients(from mockItems: [MockRecipeIngredient]) -> [RecipeIngredient] {
//            mockItems.map { m in
//                let ing = ingredient(for: m.ingredient.name)
//                if let rec = try? context.fetch(
//                    FetchDescriptor<Recipe>(predicate: #Predicate { $0.ingredients == mockItems. })
//                ).first {
//                    ingredientCache[name] = existing
//                    return existing
//                }
//                return RecipeIngredient(ingredient: ing, recipe: nil, quantity: m.quantity)
//            }
//        }
//        
    }
    
    
    //    func importMockData(context: ModelContext) {
    //        // Check: if the database already contains recipes, do not import them.
    //        let existingRecipes = try? context.fetch(FetchDescriptor<Recipe>())
    //        if (existingRecipes?.isEmpty == false) { return }
    //
    //        let mockRecipes: [MockRecipe] = storage.recipes
    //        let mockCategories: [MockCategory] = storage.categories
    //        let mockIngredients: [MockIngredient] = storage.ingredients
    //
    //        for mockCategory in mockCategories {
    //            let cat = Category()
    //        }
    //
    //        // Here is your logic for filling with Mock data.
    //        for mockCategory in mockCategories {
    //
    //            let cat = Category(name: mockCategory.name)
    //
    //            for mockRecipe in mockCategory.recipes {
    //                // Ingredient mapping
    //                let ingredients: [RecipeIngredient] = mockRecipe.ingredients.map { mockRI in
    //
    //                    // Глобальный Ingredient
    //                    let ingredient = Ingredient(name: mockRI.ingredient.name)
    //
    //                    return RecipeIngredient(
    //                        ingredient: ingredient,
    //                        quantity: mockRI.quantity
    //                    )
    //                }
    //
    //                let recipe = Recipe(
    //                    name: mockRecipe.name,
    //                    summary: mockRecipe.summary,
    //                    category: cat,
    //                    serving: mockRecipe.serving,
    //                    time: mockRecipe.time,
    //                    ingredients: ingredients,
    //                    instructions: mockRecipe.instructions,
    //                    imageData: mockRecipe.imageData
    //                )
    //
    //                context.insert(recipe)
    //            }
    //
    //            context.insert(cat)
    //        }
    //
    //        func createCategory(from mockCategory: MockCategory) -> Category {
    //            let recipes: [Recipe] = mockCategory.recipes.map { MockRecipe in
    //
    //            }
    //            let cat: Category = Category(name: mockCategory.name, recipes: mockCategory.recipes)
    //            return cat
    //        }
    //
    //        func createRecipe(from mockRecipe: MockRecipe) -> Recipe {
    //            let rec: Recipe = Recipe(
    //                name: mockRecipe.name,
    //                summary: mockRecipe.summary,
    //                category: cat,
    //                serving: mockRecipe.serving,
    //                time: mockRecipe.time,
    //                ingredients: ingredients,
    //                instructions: mockRecipe.instructions,
    //                imageData: mockRecipe.imageData
    //            )
    //            return rec
    //
    //        }
}

//    func importMockData(context: ModelContext) {
//        // Если рецепты уже есть — выходим
//        let existing = try? context.fetch(FetchDescriptor<Recipe>())
//        if (existing?.isEmpty == false) { return }
//
//        let mockCategories: [MockCategory] = storage.categories
//        // при необходимости:
//        // let mockIngredients: [MockIngredient] = storage.ingredients
//        // let mockRecipes: [MockRecipe] = storage.recipes
//
//
//        // Кеши, чтобы не создавать дубликаты
//            var categoryCache: [String: Category] = [:]
//            var ingredientCache: [String: Ingredient] = [:]
//
//        func category(for name: String) -> Category {
//                if let cached = categoryCache[name] {
//                    return cached
//                }
//                // Попробуем найти в базе (на случай повторного запуска импорта)
//                if let existing = try? context.fetch(
//                    FetchDescriptor<Category>(predicate: #Predicate { $0.name == name })
//                ).first {
//                    categoryCache[name] = existing
//                    return existing
//                }
//                let new = Category(name: name)
//                context.insert(new)
//                categoryCache[name] = new
//                return new
//            }
//
//        //Функция сохранения изображения (пример):
//
//        func saveMockImageIfNeeded(_ data: Data?) -> String? {
//                guard let data else { return nil }
//                let fileName = UUID().uuidString + ".jpg"
//                // Сохраните data в ваш ImageStorage и верните fileName
//                // try? ImageStorage.shared.save(data: data, named: fileName)
//                return fileName
//            }


