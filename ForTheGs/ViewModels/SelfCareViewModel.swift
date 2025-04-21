import SwiftUI

enum Tab {
    case home
    case calendar
    case add
    case settings
}

class SelfCareViewModel: ObservableObject {
    @Published var activities: [SelfCareActivity] = []
    @Published var selectedDate: Date = Date()
    @Published var selectedTab: Tab = .calendar
    
    func addActivity(_ activity: SelfCareActivity) {
        activities.append(activity)
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
} 