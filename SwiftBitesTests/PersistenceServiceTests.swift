// PersistenceServiceTests.swift
// SwiftBites
//
// Created by Alex Rublov on 02/12/2025.
// Copyright © 2025 Alex Rublov. All rights reserved.
//
// ========================================================

import XCTest
import SwiftData
import UIKit
@testable import SwiftBites

final class PersistenceServiceTests: XCTestCase {
    var container: ModelContainer!
    var context: ModelContext!
    var service: PersistenceService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Category.self, Ingredient.self, Recipe.self, RecipeIngredient.self, configurations: config)
        context = ModelContext(container)
        service = PersistenceService(modelContext: context)
    }

    override func tearDownWithError() throws {
        container = nil
        context = nil
        service = nil
        try super.tearDownWithError()
    }

    // MARK: - Category CRUD

    func testAddCategory() throws {
        let created = try service.addCategory(name: "Pasta")
        XCTAssertEqual(created.name, "Pasta")
    }

    func testAddCategoryUniqueness() throws {
        _ = try service.addCategory(name: "Desserts")
        XCTAssertThrowsError(try service.addCategory(name: "Desserts")) { error in
            guard case PersistenceError.categoryAlreadyExists(let name) = error else {
                return XCTFail("Expected categoryAlreadyExists")
            }
            XCTAssertEqual(name, "Desserts")
        }
    }

    func testFetchCategory() throws {
        _ = try service.addCategory(name: "Soups")
        let fetched = try service.fetchCategory(named: "Soups")
        XCTAssertEqual(fetched.name, "Soups")
    }

    func testFetchCategoryNotFound() {
        XCTAssertThrowsError(try service.fetchCategory(named: "NotExists")) { error in
            guard case PersistenceError.categoryNotFound(let name) = error else {
                return XCTFail("Expected categoryNotFound")
            }
            XCTAssertEqual(name, "NotExists")
        }
    }

    func testDeleteCategory() throws {
        _ = try service.addCategory(name: "Salads")
        XCTAssertTrue(try service.deleteCategory(name: "Salads"))
        XCTAssertThrowsError(try service.fetchCategory(named: "Salads"))
    }

    // MARK: - Ingredient CRUD

    func testAddIngredient() throws {
        let ing = try service.addIngredient(name: "Tomato")
        XCTAssertEqual(ing.name, "Tomato")
    }

    func testAddIngredientUniqueness() throws {
        _ = try service.addIngredient(name: "Mozzarella")
        XCTAssertThrowsError(try service.addIngredient(name: "Mozzarella")) { error in
            guard case PersistenceError.ingredientAlreadyExists(let name) = error else {
                return XCTFail("Expected ingredientAlreadyExists")
            }
            XCTAssertEqual(name, "Mozzarella")
        }
    }

    func testFetchIngredient() throws {
        _ = try service.addIngredient(name: "Basil")
        let ing = try service.fetchIngredient(named: "Basil")
        XCTAssertEqual(ing.name, "Basil")
    }

    func testFetchIngredientNotFound() {
        XCTAssertThrowsError(try service.fetchIngredient(named: "NotExists")) { error in
            guard case PersistenceError.ingredientNotFound(let name) = error else {
                return XCTFail("Expected ingredientNotFound")
            }
            XCTAssertEqual(name, "NotExists")
        }
    }

    func testDeleteIngredient() throws {
        _ = try service.addIngredient(name: "Olive Oil")
        XCTAssertTrue(try service.deleteIngredient(name: "Olive Oil"))
        XCTAssertThrowsError(try service.fetchIngredient(named: "Olive Oil"))
    }

    // MARK: - Recipe CRUD

    func testAddRecipeWithoutImage() async throws {
        let category = try service.addCategory(name: "Pizza")
        let ing = try service.addIngredient(name: "Flour")
        let recipeIng = RecipeIngredient(ingredient: ing, quantity: "200g")

        let recipe = try await service.addRecipe(
            name: "Margherita",
            summary: "Classic",
            category: category,
            serving: 2,
            time: 15,
            ingredients: [recipeIng],
            instructions: "Mix and bake.",
            imageData: nil
        )
        XCTAssertEqual(recipe.name, "Margherita")
        XCTAssertEqual(recipe.category?.name, "Pizza")
        XCTAssertEqual(recipe.ingredients.count, 1)
        XCTAssertNil(recipe.imageData)
    }

    func testAddRecipeWithImage() async throws {
        let dummyImage = UIImage(systemName: "photo") ?? UIImage()
        let data = dummyImage.jpegData(compressionQuality: 0.5)

        let recipe = try await service.addRecipe(
            name: "WithImage",
            summary: "Has image",
            category: nil,
            serving: 1,
            time: 5,
            ingredients: [],
            instructions: "Just test",
            imageData: data
        )
        XCTAssertNotNil(recipe.imageData)
    }

    func testAddRecipeUniqueness() async throws {
        _ = try await service.addRecipe(name: "UniqueOne")
        await XCTAssertThrowsErrorAsync({
            _ = try await self.service.addRecipe(name: "UniqueOne")
        }) { error in
            guard case PersistenceError.recipeAlreadyExists(let name) = error else {
                return XCTFail("Expected recipeAlreadyExists")
            }
            XCTAssertEqual(name, "UniqueOne")
        }
    }

    func testFetchRecipe() async throws {
        _ = try await service.addRecipe(name: "ToFetch")
        let r = try service.fetchRecipe(named: "ToFetch")
        XCTAssertEqual(r.name, "ToFetch")
    }

    func testUpdateRecipe() async throws {
        let category = try service.addCategory(name: "Pasta")
        let r = try await service.addRecipe(name: "Bolognese", category: category)
        let updated = try await service.updateRecipe(
            id: r.id,
            name: "Bolognese Updated",
            summary: "New summary",
            category: category,
            serving: 4,
            time: 30,
            ingredients: [],
            instructions: "Cook more.",
            imageData: nil
        )
        XCTAssertEqual(updated.name, "Bolognese Updated")
        XCTAssertEqual(updated.serving, 4)
        XCTAssertEqual(updated.time, 30)
    }

    func testUpdateRecipeWithImage() async throws {
        let r = try await service.addRecipe(name: "WithImage2")
        let dummyImage = UIImage(systemName: "photo") ?? UIImage()
        let data = dummyImage.jpegData(compressionQuality: 0.5)

        let updated = try await service.updateRecipe(
            id: r.id,
            name: "WithImage2",
            imageData: data
        )
        XCTAssertEqual(updated.name, "WithImage2")
        XCTAssertNotNil(updated.imageData)
    }

    func testDeleteRecipe() async throws {
        let r = try await service.addRecipe(name: "ToDelete")
        XCTAssertTrue(try service.delete(r))
        XCTAssertThrowsError(try service.fetchRecipe(named: "ToDelete"))
    }
}

// MARK: - Async helper assertion

extension XCTestCase {
    func XCTAssertThrowsErrorAsync<T>(
        _ expression: @escaping () async throws -> T,
        assert: (Error) -> Void = { _ in },
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        do {
            _ = try await expression()
            XCTFail("Expected error to be thrown", file: file, line: line)
        } catch {
            assert(error)
        }
    }
}
