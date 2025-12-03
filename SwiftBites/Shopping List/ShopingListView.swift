// ShopingListView.swift
// SwiftBites
//
// Created by Alex Rublov on 02/12/2025.
// Copyright © 2025 Alex Rublov. All rights reserved.
//
// ========================================================

import SwiftUI
import SwiftData

struct ShopingListView: View {
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ShopingIngredientsListView()
        }
    }
}

// MARK: - IngredientsListView with #Predicate and @Query

private struct ShopingIngredientsListView: View {
    
    typealias Selection = (Ingredient) -> Void
    
    let selection: Selection?
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(filter: #Predicate<Ingredient> { ingredient in
        ingredient.isAvailable == false
    }) private var ingredients: [Ingredient]
    @State private var error: Error?
    private var persistenceService: PersistenceService { PersistenceService(modelContext: modelContext) }
    
    init(selection: Selection? = nil) {
        self.selection = selection
    }
    
    var body: some View {
        content
            .navigationTitle("Shoping List")
            .toolbar {
                if !ingredients.isEmpty {
                    NavigationLink(value: IngredientForm.Mode.add) {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .navigationDestination(for: IngredientForm.Mode.self) { mode in
                IngredientForm(mode: mode)
            }
    }
    
    // MARK: - View
    
    @ViewBuilder
    private var content: some View {
        if ingredients.isEmpty {
            empty
        } else {
            list(for: ingredients)
        }
    }
    
    private var empty: some View {
        ContentUnavailableView(
            label: {
                Label("No Ingredients", systemImage: "list.clipboard")
            },
            description: {
                Text("Ingredients you add will appear here.")
            },
            actions: {
                NavigationLink("Add Ingredient", value: IngredientForm.Mode.add)
                    .buttonBorderShape(.roundedRectangle)
                    .buttonStyle(.borderedProminent)
            }
        )
    }
    
    
    private func list(for ingredients: [Ingredient]) -> some View {
        List {
            ForEach(ingredients) { ingredient in
                row(for: ingredient)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            delete(ingredient: ingredient)
                        }
                    }
            }
        }
        
        .listStyle(.plain)
    }
    
    @ViewBuilder
    private func row(for ingredient: Ingredient) -> some View {
        HStack(spacing: 12) {
            AvailableButton(isAvailable: Binding(
                get: { ingredient.isAvailable },
                set: { newValue in
                    ingredient.isAvailable = newValue
                    // Persist immediately via model context
                    do {
                        try modelContext.save()
                    } catch {
                        self.error = error
                    }
                }
            ))
            
            if let selection {
                Button(
                    action: {
                        selection(ingredient)
                        dismiss()
                    },
                    label: {
                        title(for: ingredient)
                            .contentShape(Rectangle())
                    }
                )
                .buttonStyle(.plain)
            } else {
                NavigationLink(value: IngredientForm.Mode.edit(ingredient)) {
                    title(for: ingredient)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            Spacer(minLength: 0)
        }
    }
    
    private func title(for ingredient: Ingredient) -> some View {
        Text(ingredient.name)
            .font(.title3)
    }
    
    // MARK: - Data
    
    private func delete(ingredient: Ingredient) {
        Task {
            do {
                try persistenceService.deleteIngredient(name: ingredient.name)
            } catch {
                self.error = error
            }
        }
        
    }
}

