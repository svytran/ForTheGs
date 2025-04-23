import Foundation
import SwiftData
import SwiftUI

// // MARK: - Repository Protocol
// protocol SelfCareActivityRepositoryProtocol {
//     func fetchAllActivities() -> [SelfCareActivity]
//     func addActivity(_ activity: SelfCareActivity)
//     func deleteActivity(_ activity: SelfCareActivity)
//     func updateActivity(_ activity: SelfCareActivity)
//     func getActivities(for date: Date) -> [SelfCareActivity]
// }

// // MARK: - Repository Implementation
// @MainActor
// final class SelfCareActivityRepository: SelfCareActivityRepositoryProtocol {
//     private let modelContext: ModelContext
    
//     init(modelContext: ModelContext) {
//         self.modelContext = modelContext
//     }
    
//     func fetchAllActivities() -> [SelfCareActivity] {
//         let descriptor = FetchDescriptor<SelfCareActivity>()
//         return (try? modelContext.fetch(descriptor)) ?? []
//     }
    
//     func addActivity(_ activity: SelfCareActivity) {
//         modelContext.insert(activity)
//         try? modelContext.save()
//     }
    
//     func deleteActivity(_ activity: SelfCareActivity) {
//         modelContext.delete(activity)
//         try? modelContext.save()
//     }
    
//     func updateActivity(_ activity: SelfCareActivity) {
//         try? modelContext.save()
//     }
    
//     func getActivities(for date: Date) -> [SelfCareActivity] {
//         let activities = fetchAllActivities()
//         return activities.filter { activity in
//             switch activity.recurringPattern {
//             case .fixedDays(let days):
//                 let weekday = Calendar.current.component(.weekday, from: date)
//                 return days.contains { $0.rawValue == weekday }
//             case .interval(let interval):
//                 let daysSinceStart = Calendar.current.dateComponents([.day], from: activity.startDate, to: date).day ?? 0
//                 return daysSinceStart >= 0 && daysSinceStart % interval == 0
//             }
//         }
//     }
// }

protocol SelfCareActivityRepositoryProtocol {
    func fetchActivities() -> [SelfCareActivity]
    func addActivity(_ activity: SelfCareActivity)
    func updateActivity(_ activity: SelfCareActivity)
    func deleteActivity(_ activity: SelfCareActivity)
}

class SelfCareActivityRepository: SelfCareActivityRepositoryProtocol {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        print("📚 SelfCareActivityRepository initialized")
    }
    
    func fetchActivities() -> [SelfCareActivity] {
        print("🔍 Fetching all activities...")
        let descriptor = FetchDescriptor<SelfCareActivity>(sortBy: [SortDescriptor(\.startDate)])
        let activities = (try? modelContext.fetch(descriptor)) ?? []
        print("📊 Found \(activities.count) activities")
        return activities
    }
    
    func addActivity(_ activity: SelfCareActivity) {
        print("➕ Adding activity to database: \(activity.name)")
        modelContext.insert(activity)
        do {
            try modelContext.save()
            print("✅ Activity saved successfully")
        } catch {
            print("❌ Failed to save activity: \(error)")
        }
    }
    
    func updateActivity(_ activity: SelfCareActivity) {
        print("🔄 Updating activity in database: \(activity.name)")
        do {
            try modelContext.save()
            print("✅ Activity updated successfully")
        } catch {
            print("❌ Failed to update activity: \(error)")
        }
    }
    
    func deleteActivity(_ activity: SelfCareActivity) {
        print("🗑️ Deleting activity from database: \(activity.name)")
        modelContext.delete(activity)
        do {
            try modelContext.save()
            print("✅ Activity deleted successfully")
        } catch {
            print("❌ Failed to delete activity: \(error)")
        }
    }
}