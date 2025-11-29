import SwiftUI
import SwiftData

@main
struct SwiftBitesApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Recipe.self,
            RecipeIngredient.self,
            Ingredient.self,
            Category.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)
            //                .environment(\.storage, Storage())
        }
    }
}
//
//@main
//struct SwiftBitesApp: App {
//  var body: some Scene {
//    WindowGroup {
//      ContentView()
//        .environment(\.storage, Storage())
//    }
//  }
//}

//
//import SwiftUI
//import SwiftData
//
//
//@main
//struct SwiftBitesApp: App {
//var body: some Scene {
//WindowGroup {
//ContentView()
//.modelContainer(try! Persistence.makeModelContainer())
//}
//}
//}

//
//@main
//struct MyApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//        .modelContainer(for: [
//            Recipe.self,
//            RecipeIngredient.self,
//            Ingredient.self,
//            Category.self
//        ])
//    }
//}
