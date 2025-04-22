import SwiftUI

class AddActivityViewModel: ObservableObject {
    @Published var name = ""
    @Published var selectedIcon = "heart.fill"
    @Published var selectedColor = Color.red
    @Published var selectedDays: Set<RecurringPattern.Weekday> = []
    @Published var intervalDays = 1
    @Published var patternType = PatternType.fixedDays
    @Published var description = ""
    
    private let selfCareViewModel: SelfCareViewModel
    let initialStartDate: Date
    
    enum PatternType {
        case fixedDays
        case interval
    }
    
    init(selfCareViewModel: SelfCareViewModel, initialStartDate: Date) {
        self.selfCareViewModel = selfCareViewModel
        self.initialStartDate = initialStartDate
    }
    
    var isValid: Bool {
        !name.isEmpty && (patternType == .interval || !selectedDays.isEmpty)
    }
    
    func formatWeekday(_ day: RecurringPattern.Weekday) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"  // Full weekday name
        let date = Calendar.current.date(from: DateComponents(weekday: day.rawValue)) ?? Date()
        return formatter.string(from: date)
    }
    
    func toggleDay(_ day: RecurringPattern.Weekday) {
        if selectedDays.contains(day) {
            selectedDays.remove(day)
        } else {
            selectedDays.insert(day)
        }
    }
    
    func save() {
        let pattern: RecurringPattern
        if patternType == .fixedDays {
            pattern = .fixedDays(Array(selectedDays))
        } else {
            pattern = .interval(intervalDays)
        }
        
        let activity = SelfCareActivity(
            name: name,
            icon: selectedIcon,
            color: selectedColor,
            pattern: pattern,
            startDate: initialStartDate,
            description: description.isEmpty ? nil : description
        )
        
        selfCareViewModel.addActivity(activity)
    }
} 