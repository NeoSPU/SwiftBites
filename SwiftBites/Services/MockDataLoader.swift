// MockDataLoader.swift
// SwiftBites
//
// Created by Alex Rublov on 23/11/2025.
// Copyright © 2025 Alex Rublov. All rights reserved.
//
// ========================================================

import Foundation

struct MockDataLoader {}
    
//    // Import function
//    func importMockDataIfNeeded(context: ModelContext, mockCategories: [MockCategory]) {
//    // Avoid repeated imports
//    let existing: [Recipe] = (try? context.fetch(FetchDescriptor<Recipe>())) ?? []
//    if !existing.isEmpty { return }
//
//
//    for mockCat in mockCategories {
//    let cat = Category(name: mockCat.name)
//    context.insert(cat)
//
//
//    for mockRecipe in mockCat.recipes {
//    // upsert Ingredients to global list to prevent duplicates
//    var riObjects: [RecipeIngredient] = []
//    for mockRI in mockRecipe.ingredients {
//    // find existing Ingredient by name
//    let fd = FetchDescriptor<Ingredient>(predicate: #Predicate { (i: Ingredient) -> Bool in
//    i.name.lowercased() == mockRI.ingredient.name.lowercased()
//    })
//    let found: [Ingredient] = (try? context.fetch(fd)) ?? []
//
//
//    let ing: Ingredient
//    if let first = found.first {
//    ing = first
//    } else {
//    ing = Ingredient(name: mockRI.ingredient.name)
//    context.insert(ing)
//    }
//
//
//    let ri = RecipeIngredient(ingredient: ing, quantity: mockRI.quantity)
//    riObjects.append(ri)
//    }
//
//
//    // Save image externally if present
//    var imageFileName: String? = nil
//    if let data = mockRecipe.imageData, let ui = UIImage(data: data) {
//    let id = UUID()
//    if let filename = try? ImageStorage.shared.save(image: ui, id: id) {
//    imageFileName = filename
//    }
//    }
//
//
//    let r = Recipe(
//    name: mockRecipe.name,
//    summary: mockRecipe.summary,
//    category: cat,
//    serving: mockRecipe.serving,
//    time: mockRecipe.time,
//    ingredients: riObjects,
//    instructions: mockRecipe.instructions,
//    imageFile: imageFileName
//    )
//
//
//    context.insert(r)
//    }
//    }
//
//
//    try? context.save()
//    }
    // Import function
//    func importMockDataIfNeeded(context: ModelContext, mockCategories: [MockCategory]) {
//    // Avoid repeated imports
//    let existing: [Recipe] = (try? context.fetch(FetchDescriptor<Recipe>())) ?? []
//    if !existing.isEmpty { return }
//
//
//    for mockCat in mockCategories {
//    let cat = Category(name: mockCat.name)
//    context.insert(cat)
//
//
//    for mockRecipe in mockCat.recipes {
//    // upsert Ingredients to global list to prevent duplicates
//    var riObjects: [RecipeIngredient] = []
//    for mockRI in mockRecipe.ingredients {
//    // find existing Ingredient by name
//    let fd = FetchDescriptor<Ingredient>(predicate: #Predicate { (i: Ingredient) -> Bool in
//    i.name.lowercased() == mockRI.ingredient.name.lowercased()
//    })
//    let found: [Ingredient] = (try? context.fetch(fd)) ?? []
//
//
//    let ing: Ingredient
//    if let first = found.first {
//    ing = first
//    } else {
//    ing = Ingredient(name: mockRI.ingredient.name)
//    context.insert(ing)
//    }
//
//
//    let ri = RecipeIngredient(ingredient: ing, quantity: mockRI.quantity)
//    riObjects.append(ri)
//    }
//
//
//    // Save image externally if present
//    var imageFileName: String? = nil
//    if let data = mockRecipe.imageData, let ui = UIImage(data: data) {
//    let id = UUID()
//    if let filename = try? ImageStorage.shared.save(image: ui, id: id) {
//    imageFileName = filename
//    }
//    }
//
//
//    let r = Recipe(
//    name: mockRecipe.name,
//    summary: mockRecipe.summary,
//    category: cat,
//    serving: mockRecipe.serving,
//    time: mockRecipe.time,
//    ingredients: riObjects,
//    instructions: mockRecipe.instructions,
//    imageFile: imageFileName
//    )
//
//
//    context.insert(r)
//    }
//    }
//
//
//    try? context.save()
//    }
//}


//func importMockData(context: ModelContext) {
//    // Проверь: если БД уже содержит рецепты — не импортируем
//    let existingRecipes = try? context.fetch(FetchDescriptor<Recipe>())
//    if (existingRecipes?.isEmpty == false) { return }
//
//    // Здесь ваша логика заполнения Mock-данными
//    for mockCategory in mockCategories {
//        
//        let cat = Category(name: mockCategory.name)
//
//        for mockRecipe in mockCategory.recipes {
//            // Ingredient mapping
//            let ingredients: [RecipeIngredient] = mockRecipe.ingredients.map { mockRI in
//                
//                // Глобальный Ingredient
//                let ingredient = Ingredient(name: mockRI.ingredient.name)
//
//                return RecipeIngredient(
//                    ingredient: ingredient,
//                    quantity: mockRI.quantity
//                )
//            }
//
//            let recipe = Recipe(
//                name: mockRecipe.name,
//                summary: mockRecipe.summary,
//                category: cat,
//                serving: mockRecipe.serving,
//                time: mockRecipe.time,
//                ingredients: ingredients,
//                instructions: mockRecipe.instructions,
//                imageData: mockRecipe.imageData
//            )
//
//            context.insert(recipe)
//        }
//
//        context.insert(cat)
//    }
//}
