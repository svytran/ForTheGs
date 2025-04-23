import SwiftUI
import SwiftData

enum Tab {
    case home
    case calendar
    case add
    case settings
}

@MainActor
class SelfCareViewModel: ObservableObject {
    private let repository: SelfCareActivityRepositoryProtocol
    @Published var activities: [SelfCareActivity] = []
    @Published var selectedDate: Date = Date()
    @Published var selectedTab: Tab = .calendar
    
    init(repository: SelfCareActivityRepositoryProtocol) {
        self.repository = repository
        self.activities = repository.fetchActivities()
    }
    
    func addActivity(_ activity: SelfCareActivity) {
        repository.addActivity(activity)
        activities = repository.fetchActivities()
    }
    
    func getActivities(for date: Date) -> [SelfCareActivity] {
        return activities.filter { activity in
            switch activity.pattern {
            case .fixedDays(let days):
                let weekday = Calendar.current.component(.weekday, from: date)
                return days.contains { $0.rawValue == weekday }
            case .interval(let interval):
                let daysSinceStart = Calendar.current.dateComponents([.day], from: activity.startDate, to: date).day ?? 0
                return daysSinceStart >= 0 && daysSinceStart % interval == 0
            }
        }
    }
    
    func updateActivity(_ updatedActivity: SelfCareActivity) {
        repository.updateActivity(updatedActivity)
        activities = repository.fetchActivities()
    }
    
    func deleteActivity(_ activity: SelfCareActivity) {
        repository.deleteActivity(activity)
        activities = repository.fetchActivities()
    }
} 
