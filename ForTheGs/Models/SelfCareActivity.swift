import SwiftUI

struct SelfCareActivity: Identifiable, Equatable {
    let id: UUID
    let name: String
    let icon: String
    let color: Color
    let pattern: RecurringPattern
    let startDate: Date
    let description: String?
    
    init(
        id: UUID = UUID(),
        name: String,
        icon: String,
        color: Color,
        pattern: RecurringPattern,
        startDate: Date,
        description: String? = nil
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
        self.pattern = pattern
        self.startDate = startDate
        self.description = description
    }
    
    static func == (lhs: SelfCareActivity, rhs: SelfCareActivity) -> Bool {
        lhs.id == rhs.id
    }
}

enum RecurringPattern {
    case fixedDays([RecurringPattern.Weekday])
    case interval(Int)  // Every X days
    
    enum Weekday: Int, CaseIterable {
        case sunday = 1
        case monday = 2
        case tuesday = 3
        case wednesday = 4
        case thursday = 5
        case friday = 6
        case saturday = 7
    }
} 