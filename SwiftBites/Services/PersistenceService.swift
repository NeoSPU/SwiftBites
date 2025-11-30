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
    
    var errorDescription: String? {
        switch self {
        case .categoryAlreadyExists(let name):
            return "Category with name \"\(name)\" already exists."
        case .categoryNotFound(let name):
            return "Category with name \"\(name)\" was not found."
        }
    }
}

final class PersistenceService {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    @discardableResult
    func addCategory(name: String) throws -> Category {
        // Enforce uniqueness by checking for an existing category with the same name
        let descriptor = FetchDescriptor<Category>(
            predicate: #Predicate { $0.name == name },
            sortBy: []
        )
        if let _ = try? modelContext.fetch(descriptor).first {
            throw PersistenceError.categoryAlreadyExists(name: name)
        }
        let newCategory = Category(name: name)
        modelContext.insert(newCategory)
        return newCategory
    }
    
    @discardableResult
    func deleteCategory(name: String) throws -> Bool {
        // Fetch the category with the given name and delete it if found
        let descriptor = FetchDescriptor<Category>(
            predicate: #Predicate { $0.name == name },
            sortBy: []
        )
        if let category = try modelContext.fetch(descriptor).first {
            modelContext.delete(category)
            return true
        } else {
            throw PersistenceError.categoryNotFound(name: name)
        }
    }
    
    @discardableResult
    func updateCategory(name: String) throws -> Category {
        // Enforce uniqueness by checking for an existing category with the same name
        let descriptor = FetchDescriptor<Category>(
            predicate: #Predicate { $0.name == name },
            sortBy: []
        )
        if let _ = try? modelContext.fetch(descriptor).first {
            let newCategory = Category(name: name)
            modelContext.insert(newCategory)
            return newCategory
        } else {
            throw PersistenceError.categoryNotFound(name: name)
        }
    
    }
}

