import SwiftUI

@MainActor
final class DescriptionsViewModel: ObservableObject {
    @Published private(set) var activities: [SelfCareActivity]
    @Published private(set) var expandedActivities: Set<UUID> = []
    
    init(activities: [SelfCareActivity]) {
        self.activities = activities
    }
    
    // MARK: - Public Methods
    
    func toggleActivityExpansion(_ activityId: UUID) {
        if expandedActivities.contains(activityId) {
            expandedActivities.remove(activityId)
        } else {
            expandedActivities.insert(activityId)
        }
    }
    
    func isActivityExpanded(_ activityId: UUID) -> Bool {
        expandedActivities.contains(activityId)
    }
    
    func getScheduleDescription(for activity: SelfCareActivity) -> String {
        switch activity.pattern {
        case .fixedDays(let days):
            return "Every \(days.map { $0.description }.joined(separator: ", "))"
        case .interval(let interval):
            return "Every \(interval) day\(interval == 1 ? "" : "s")"
        }
    }
    
    func getStartDateDescription(for activity: SelfCareActivity) -> String {
        activity.startDate.formatted(date: .long, time: .omitted)
    }
} 