//
//  ForTheGsApp.swift
//  ForTheGs
//
//  Created by Shana Tran on 4/21/25.
//

import SwiftUI

@main
struct ForTheGsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// import SwiftUI
// import SwiftData

// @main
// struct ForTheGsApp: App {
//     let container: ModelContainer
    
//     init() {
//         do {
//             container = try ModelContainer(for: SelfCareActivity.self)
//         } catch {
//             fatalError("Failed to initialize ModelContainer: \(error)")
//         }
//     }
    
//     var body: some Scene {
//         WindowGroup {
//             ContentView(repository: SelfCareActivityRepository(modelContext: container.mainContext))
//         }
//         .modelContainer(container)
//     }
// }

// struct ContentView: View {
//     let repository: SelfCareActivityRepositoryProtocol
    
//     var body: some View {
//         MainTabView(repository: repository)
//     }
// }
