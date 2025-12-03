import SwiftUI
import SwiftData

struct IngredientsView: View {
    typealias Selection = (Ingredient) -> Void
    
    let selection: Selection?
    
    init(selection: Selection? = nil) {
        self.selection = selection
    }
    
    @State private var query = ""
    @State private var sortOrder: SortDescriptor<Ingredient> = SortDescriptor(\Ingredient.name)
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            IngredientsListView(query: query, sortOrder: sortOrder, selection: selection)
                .searchable(text: $query)
                .toolbar {sortOptions}
        }
    }
    
    @ToolbarContentBuilder
    var sortOptions: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Menu("Sort", systemImage: "arrow.up.arrow.down") {
                Picker("Sort", selection: $sortOrder) {
                    Text("Ingredient (A–Z)")
                        .tag(SortDescriptor<Ingredient>(\.name, order: .forward))
                    Text("Ingredient (Z–A)")
                        .tag(SortDescriptor<Ingredient>(\.name, order: .reverse))
                }
            }
            .pickerStyle(.inline)
        }
    }
}

 // MARK: - IngredientsListView with #Predicate and @Query

private struct IngredientsListView: View {
    typealias Selection = (Ingredient) -> Void
    
    let query: String
    let sortOrder: SortDescriptor<Ingredient>
    let selection: Selection?
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var ingredients: [Ingredient]
    @State private var error: Error?
    private var persistenceService: PersistenceService { PersistenceService(modelContext: modelContext) }
    
    
    init(query: String, sortOrder: SortDescriptor<Ingredient>, selection: Selection? = nil) {
        self.query = query
        self.sortOrder = sortOrder
        self.selection = selection
        
        // Build a #Predicate based on the current query. If empty, match all.
        let predicate: Predicate<Ingredient>
        if query.isEmpty {
            predicate = #Predicate<Ingredient> { _ in true }
        } else {
            let q = query
            predicate = #Predicate<Ingredient> { ingredient in
                ingredient.name.localizedStandardContains(q)
            }
        }
        
        // Initialize the @Query wrapper with filter and sort so filtering/sorting happen in the store.
        self._ingredients = Query(filter: predicate, sort: [sortOrder])
    }
    
    var body: some View {
        content
            .navigationTitle("Ingredients")
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
    
    private var noResults: some View {
        ContentUnavailableView(
            label: {
                Text("Couldn't find \"\(query)\"")
            }
        )
        .listRowSeparator(.hidden)
    }
    
    private func list(for ingredients: [Ingredient]) -> some View {
        List {
            if ingredients.isEmpty {
                noResults
            } else {
                ForEach(ingredients) { ingredient in
                    row(for: ingredient)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button("Delete", systemImage: "trash", role: .destructive) {
                                delete(ingredient: ingredient)
                            }
                        }
                }
            }
        }
        .listStyle(.plain)
    }
    
    @ViewBuilder
    private func row(for ingredient: Ingredient) -> some View {
        if let selection {
            Button(
                action: {
                    selection(ingredient)
                    dismiss()
                },
                label: {
                    title(for: ingredient)
                }
            )
        } else {
            NavigationLink(value: IngredientForm.Mode.edit(ingredient)) {
                title(for: ingredient)
            }
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
