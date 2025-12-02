import SwiftUI

struct IngredientForm: View {
    enum Mode: Hashable {
        case add
        case edit(Ingredient)
    }
    
    var mode: Mode
    
    init(mode: Mode) {
        self.mode = mode
        switch mode {
        case .add:
            _name = .init(initialValue: "")
            title = "Add Ingredient"
        case .edit(let ingredient):
            _name = .init(initialValue: ingredient.name)
            title = "Edit \(ingredient.name)"
        }
    }
    
    private let title: String
    @State private var name: String
    @State private var error: Error?
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isNameFocused: Bool
    private var persistenceService: PersistenceService { PersistenceService(modelContext: modelContext) }
    
    // MARK: - Body
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name)
                    .focused($isNameFocused)
            }
            if case .edit(let ingredient) = mode {
                Button(
                    role: .destructive,
                    action: {
                        Task {
                            do {
                                try persistenceService.deleteIngredient(name: ingredient.name)
                                await MainActor.run { dismiss() }
                            } catch {
                                await MainActor.run { self.error = error }
                            }
                        }
                    },
                    label: {
                        Text("Delete Ingredient")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                )
            }
        }
        .onAppear {
            isNameFocused = true
        }
        .onSubmit {
            save()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save", action: save)
                    .disabled(name.isEmpty)
            }
        }
    }
    
    // MARK: - Actions
    
    private func save() {
        Task {
            do {
                switch mode {
                case .add:
                    try persistenceService.addIngredient(name: name)
                case .edit(_):
                    try persistenceService.updateIngredient(name: name)
                }
                await MainActor.run { dismiss() }
            } catch {
                await MainActor.run { self.error = error }
            }
        }
    }
    
    private func delete(ingredient: Ingredient) {
        do {
            try persistenceService.deleteIngredient(name: ingredient.name)
            dismiss()
        } catch {
            self.error = error
        }
    }
}

