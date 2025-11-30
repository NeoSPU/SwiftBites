// Category.swift
// SwiftBites
//
// Created by Alex Rublov on 22/11/2025.
// Copyright © 2025 Alex Rublov. All rights reserved.
//
// ========================================================

import Foundation
import SwiftData

@Model
final class Category {
    @Attribute(.unique) var id: UUID
    var name: String
    @Relationship(deleteRule: .nullify, inverse: \Recipe.category)
    var recipes: [Recipe] = []

    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}
