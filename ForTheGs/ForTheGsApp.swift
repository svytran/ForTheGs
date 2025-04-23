//
//  ForTheGsApp.swift
//  ForTheGs
//
//  Created by Shana Tran on 4/21/25.
//
//
//import SwiftUI
//import SwiftData
//
//@main
//struct ForTheGsApp: App {
//    let container: ModelContainer
//    
//    init() {
//        // Register the RecurringPattern transformer
//        RecurringPatternTransformer.register()
//        
//        do {
//            container = try ModelContainer(for: SelfCareActivity.self)
//        } catch {
//            fatalError("Failed to initialize ModelContainer: \(error)")
//        }
//    }
//    
//    var body: some Scene {
//        WindowGroup {
//            ContentView(repository: SelfCareActivityRepository(modelContext: container.mainContext))
//        }
//        .modelContainer(container)
//    }
//}
//
//struct ContentView: View {
//    let repository: SelfCareActivityRepositoryProtocol
//    
//    var body: some View {
//        MainTabView(repository: repository)
//    }
//}

import SwiftUI
import SwiftData

@main
struct ForTheGsApp: App {
    let container: ModelContainer

    init() {
        print("📱 ForTheGs App initializing...")
        
        do {
            print("📦 Creating ModelContainer...")
            let config = ModelConfiguration(isStoredInMemoryOnly: false)
            container = try ModelContainer(for: SelfCareActivity.self, configurations: config)
            print("✅ ModelContainer initialized successfully")
        } catch {
            print("❌ Failed to initialize ModelContainer: \(error)")
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
        
        print("✅ ForTheGs App initialization complete")
    }

    var body: some Scene {
        WindowGroup {
            ContentView(repository: SelfCareActivityRepository(modelContext: container.mainContext))
                .modelContainer(container)
        }
    }
}
