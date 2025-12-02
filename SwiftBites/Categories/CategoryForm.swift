import SwiftUI

struct CategoryForm: View {
    
    enum Mode: Hashable {
        case add
        case edit(Category)
    }
    
    var mode: Mode
    
    init(mode: Mode) {
        self.mode = mode
        switch mode {
        case .add:
            _name = .init(initialValue: "")
            title = "Add Category"
        case .edit(let category):
            _name = .init(initialValue: category.name)
            title = "Edit \(category.name)"
        }
    }
    
    private let title: String
    @State private var name: String
    @State private var error: Error?
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isNameFocused: Bool
    
    // MARK: - Body
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name)
                    .focused($isNameFocused)
            }
            if case .edit(let category) = mode {
                Button(
                    role: .destructive,
                    action: {
                        delete(category: category)
                    },
                    label: {
                        Text("Delete Category")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                )
            }
        }
        .onAppear {
            isNameFocused = true
        }
        .onSubmit {
            save(name: name)
        }
        .alert(error: $error)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    save(name: name)
                }
                .disabled(name.isEmpty)
            }
        }
    }
    
    // MARK: - Data
    
    private func delete(category: Category) {
        Task {
            do {
                try PersistenceService(modelContext: modelContext).deleteCategory(name: category.name)
                await MainActor.run { dismiss() }
            } catch {
                await MainActor.run { self.error = error }
            }
        }
    }
    
    private func save(name: String) {
        Task {
            do {
                switch mode {
                case .add:
                    try PersistenceService(modelContext: modelContext).addCategory(name: name)
                case .edit(_):
                    try PersistenceService(modelContext: modelContext).updateCategory(name: name)
                }
                await MainActor.run { dismiss() }
            } catch {
                await MainActor.run { self.error = error }
            }
        }
    }
}

