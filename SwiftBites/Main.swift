import SwiftUI
import SwiftData

/// The main view that appears when the app is launched.
struct ContentView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Environment(\.storage) private var storage
    
    var body: some View {
        TabView {
            RecipesView()
                .tabItem {
                    Label("Recipes", systemImage: "frying.pan")
                }
            
            CategoriesView()
                .tabItem {
                    Label("Categories", systemImage: "tag")
                }
            
            IngredientsView()
                .tabItem {
                    Label("Ingredients", systemImage: "carrot")
                }
            
            ShopingListView()
                .tabItem {
                    Label("Shoping List", systemImage: "basket")
                }
        }
        .onAppear {
            // Use the commented code to import mock data from storage.
//            storage.load()
//            Task {
//                await MockDataLoader(storage: storage).importMockData(context: modelContext)
//            }
        }
    }
}
