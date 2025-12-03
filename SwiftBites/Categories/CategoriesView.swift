import SwiftUI
import SwiftData

struct CategoriesView: View {
    @State private var query = ""
    @State private var sortOrder: SortDescriptor<Category> = SortDescriptor(\Category.name)

    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            CategoriesListView(query: query, sortOrder: sortOrder)
                .navigationTitle("Categories")
                .toolbar {
                    sortOptions
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(value: CategoryForm.Mode.add) {
                            Label("Add", systemImage: "plus")
                        }
                    }
                }
                .navigationDestination(for: CategoryForm.Mode.self) { mode in
                    CategoryForm(mode: mode)
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
                        .tag(SortDescriptor<Category>(\.name, order: .forward))
                    Text("Name (Z–A)")
                        .tag(SortDescriptor<Category>(\.name, order: .reverse))
                }
            }
            .pickerStyle(.inline)
        }
    }
}

// MARK: - CategoriesListView with #Predicate and @Query

private struct CategoriesListView: View {
    let query: String
    let sortOrder: SortDescriptor<Category>
    
    @Query private var categories: [Category]
    
    init(query: String, sortOrder: SortDescriptor<Category>) {
        self.query = query
        self.sortOrder = sortOrder
        
        // Build a #Predicate based on the current query. If empty, match all.
        let predicate: Predicate<Category>
        if query.isEmpty {
            predicate = #Predicate<Category> { _ in true }
        } else {
            let q = query
            predicate = #Predicate<Category> { category in
                category.name.localizedStandardContains(q)
            }
        }
        
        // Initialize the @Query wrapper with filter and sort so filtering/sorting happen in the store.
        self._categories = Query(filter: predicate, sort: [sortOrder])
    }
    
    var body: some View {
        if categories.isEmpty {
            ContentUnavailableView(
                label: { Label("No Categories", systemImage: "list.clipboard") },
                description: { Text("Categories you add will appear here.") },
                actions: {
                    NavigationLink("Add Category", value: CategoryForm.Mode.add)
                        .buttonBorderShape(.roundedRectangle)
                        .buttonStyle(.borderedProminent)
                }
            )
        } else {
            ScrollView(.vertical) {
                LazyVStack(spacing: 10) {
                    ForEach(categories, content: CategorySection.init)
                }
            }
        }
    }
}
