import SwiftUI
import SwiftData

struct RecipesView: View {
    @State private var query = ""
    @State private var sortOrder: SortDescriptor<Recipe> = SortDescriptor(\Recipe.name)
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            RecipesListView(query: query, sortOrder: sortOrder)
                .navigationTitle("Recipes")
                .toolbar {
                    sortOptions
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(value: RecipeForm.Mode.add) {
                            Label("Add", systemImage: "plus")
                        }
                    }
                }
                .navigationDestination(for: RecipeForm.Mode.self) { mode in
                    RecipeForm(mode: mode)
                }
                .searchable(text: $query)
        }
    }
    
    // MARK: - Views
    
    @ToolbarContentBuilder
    var sortOptions: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Menu("Sort", systemImage: "arrow.up.arrow.down") {
                Picker("Sort", selection: $sortOrder) {
                    Text("Name (A–Z)")
                        .tag(SortDescriptor<Recipe>(\.name, order: .forward))
                    
                    Text("Name (Z–A)")
                        .tag(SortDescriptor<Recipe>(\.name, order: .reverse))
                    
                    Text("Serving (low to high)")
                        .tag(SortDescriptor<Recipe>(\.serving, order: .forward))
                    
                    Text("Serving (high to low)")
                        .tag(SortDescriptor<Recipe>(\.serving, order: .reverse))
                    
                    Text("Time (short to long)")
                        .tag(SortDescriptor<Recipe>(\.time, order: .forward))
                    
                    Text("Time (long to short)")
                        .tag(SortDescriptor<Recipe>(\.time, order: .reverse))
                }
            }
            .pickerStyle(.inline)
        }
    }
}

// MARK: - RecipesListView with #Predicate and @Query

private struct RecipesListView: View {
    let query: String
    let sortOrder: SortDescriptor<Recipe>
    
    @Query private var recipes: [Recipe]
    
    init(query: String, sortOrder: SortDescriptor<Recipe>) {
        self.query = query
        self.sortOrder = sortOrder
        
        // Build a #Predicate based on the current query. If empty, match all.
        let predicate: Predicate<Recipe>
        if query.isEmpty {
            predicate = #Predicate<Recipe> { _ in true }
        } else {
            let q = query
            predicate = #Predicate<Recipe> { recipe in
                recipe.name.localizedStandardContains(q) ||
                recipe.summary.localizedStandardContains(q)
            }
        }
        
        // Initialize the @Query wrapper with filter and sort so filtering/sorting happen in the store.
        self._recipes = Query(filter: predicate, sort: [sortOrder])
    }
    
    var body: some View {
        if recipes.isEmpty {
            ContentUnavailableView(
                label: { Label("No Recipes", systemImage: "list.clipboard") },
                description: { Text("Recipes you add will appear here.") },
                actions: {
                    NavigationLink("Add Recipe", value: RecipeForm.Mode.add)
                        .buttonBorderShape(.roundedRectangle)
                        .buttonStyle(.borderedProminent)
                }
            )
        } else {
            ScrollView(.vertical) {
                LazyVStack(spacing: 10) {
                    ForEach(recipes, content: RecipeCell.init)
                }
            }
        }
    }
}
