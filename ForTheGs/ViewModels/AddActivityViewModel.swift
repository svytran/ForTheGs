import SwiftUI

class AddActivityViewModel: ObservableObject {
    @Published var name = ""
    @Published var selectedIcon = "heart.fill"
    @Published var selectedColor = Color.red
    @Published var selectedDays: Set<RecurringPattern.Weekday> = []
    @Published var intervalDays = 1
    @Published var patternType = PatternType.fixedDays
    @Published var activityDescription = ""
    
    private let selfCareViewModel: SelfCareViewModel
    let initialStartDate: Date
    let editingActivity: SelfCareActivity?
    
    enum PatternType {
        case fixedDays
        case interval
    }
    
    init(selfCareViewModel: SelfCareViewModel, initialStartDate: Date, editingActivity: SelfCareActivity? = nil) {
        self.selfCareViewModel = selfCareViewModel
        self.initialStartDate = initialStartDate
        self.editingActivity = editingActivity
        
        if let activity = editingActivity {
            // Pre-fill the form with activity data
            self.name = activity.name
            self.selectedIcon = activity.icon
            self.selectedColor = activity.color
            self.activityDescription = activity.activityDescription ?? ""
            
            switch activity.pattern {
            case .fixedDays(let days):
                self.patternType = .fixedDays
                self.selectedDays = Set(days)
            case .interval(let interval):
                self.patternType = .interval
                self.intervalDays = interval
            }
        }
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
    
    @MainActor
    func save() {
        print("📝 Creating new activity...")
        let pattern: RecurringPattern
        if patternType == .fixedDays {
            pattern = .fixedDays(Array(selectedDays))
            print("📅 Pattern type: Fixed Days - \(selectedDays.map { $0.rawValue })")
        } else {
            pattern = .interval(intervalDays)
            print("🔄 Pattern type: Interval - Every \(intervalDays) days")
        }
        
        let activity = SelfCareActivity(
            id: editingActivity?.id ?? UUID(),
            name: name,
            icon: selectedIcon,
            color: selectedColor,
            pattern: pattern,
            startDate: editingActivity?.startDate ?? initialStartDate,
            activityDescription: activityDescription.isEmpty ? nil : activityDescription
        )
        print("✅ Activity created: \(activity.name) with pattern: \(pattern)")
        
        if editingActivity != nil {
            print("🔄 Updating existing activity...")
            selfCareViewModel.updateActivity(activity)
        } else {
            print("➕ Adding new activity...")
            selfCareViewModel.addActivity(activity)
        }
        print("✅ Activity saved successfully")
    }
} 
