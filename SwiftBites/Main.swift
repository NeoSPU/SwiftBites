import SwiftUI

/// The main view that appears when the app is launched.
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

//    @Environment(\.storage) private var storage
    //    @Environment(\.modelContext) private var context
    
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
        }
        .onAppear {
//            storage.load()
        }
    }
}


//var body: some View {
//    NavigationView {
//        Text("SwiftBites — Home")
//            .padding()
//            .navigationTitle("SwiftBites")
//            .task {
//                // supply your real mock array here or load from bundled json
//                let mockCategories: [MockCategory] = [] // fill in
//                importMockDataIfNeeded(context: context, mockCategories: mockCategories)
//            }
//    }
//}

//
//struct ContentView: View {
//    @Environment(\.modelContext) private var context
//
//    var body: some View {
//        HomeView()
//            .onAppear {
//                importMockData(context: context)
//            }
//    }
//}

