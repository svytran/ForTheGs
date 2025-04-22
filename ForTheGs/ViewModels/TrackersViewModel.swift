// import SwiftUI
// import SwiftData

// // MARK: - ViewModel
// @MainActor
// final class TrackersViewModel: ObservableObject {
//     @Published private(set) var activities: [SelfCareActivity] = []
//     @Published var completedActivities: Set<UUID> = []
    
//     private let repository: SelfCareActivityRepositoryProtocol
    
//     init(repository: SelfCareActivityRepositoryProtocol) {
//         self.repository = repository
//         loadActivities()
//     }
    
//     // MARK: - Public Methods
//     func loadActivities() {
//         activities = repository.fetchAllActivities()
//     }
    
//     func toggleCompletion(for activityId: UUID) {
//         if completedActivities.contains(activityId) {
//             completedActivities.remove(activityId)
//         } else {
//             completedActivities.insert(activityId)
//         }
//     }
    
//     func isCompleted(_ activity: SelfCareActivity) -> Bool {
//         completedActivities.contains(activity.id)
//     }
    
//     func deleteActivity(_ activity: SelfCareActivity) {
//         repository.deleteActivity(activity)
//         loadActivities()
//     }
// }