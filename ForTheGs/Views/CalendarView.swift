import SwiftUI

struct CalendarView: View {
    @Binding var selectedDate: Date
    @ObservedObject var viewModel: SelfCareViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.pink.opacity(0.1),
                    Color.white
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Calendar Header
                    HStack {
                        Text(monthYearString)
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        HStack(spacing: 20) {
                            Button(action: previousMonth) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.pink.opacity(0.9))
                                    .imageScale(.large)
                            }
                            Button(action: nextMonth) {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.pink.opacity(0.9))
                                    .imageScale(.large)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Weekday headers
                    HStack {
                        ForEach(weekdaySymbols, id: \.self) { symbol in
                            Text(symbol)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Calendar grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 7), spacing: 12) {
                        ForEach(daysInMonth, id: \.self) { date in
                            if let date = date {
                                DayCell(
                                    date: date,
                                    isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                                    activities: activitiesForDate(date),
                                    onTap: { self.selectedDate = date }
                                )
                            } else {
                                Color.clear
                                    .aspectRatio(1, contentMode: .fill)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Weekly view
                    WeeklyView(
                        selectedDate: selectedDate,
                        viewModel: viewModel
                    )
                    .padding(.bottom, 20)
                }
            }
        }
        .toolbarBackground(Color.pink.opacity(0.2), for: .navigationBar)
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedDate)
    }
    
    private var weekdaySymbols: [String] {
        let formatter = DateFormatter()
        return formatter.veryShortWeekdaySymbols
    }
    
    private var daysInMonth: [Date?] {
        let calendar = Calendar.current
        
        // Get start of the month
        let interval = calendar.dateInterval(of: .month, for: selectedDate)!
        let firstDay = interval.start
        
        // Get the weekday of the first day (0 = Sunday)
        let firstWeekday = calendar.component(.weekday, from: firstDay)
        
        // Calculate leading empty cells
        let leadingEmptyCells = firstWeekday - 1
        
        // Get the number of days in the month
        let daysInMonth = calendar.range(of: .day, in: .month, for: selectedDate)!.count
        
        var days: [Date?] = Array(repeating: nil, count: leadingEmptyCells)
        
        // Add the actual dates
        for day in 1...daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay) {
                days.append(date)
            }
        }
        
        // Add trailing empty cells to complete the grid
        let totalCells = 42 // 6 rows × 7 days
        while days.count < totalCells {
            days.append(nil)
        }
        
        return days
    }
    
    private func activitiesForDate(_ date: Date) -> [SelfCareActivity] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        
        return viewModel.activities.filter { activity in
            let activityStartDate = calendar.startOfDay(for: activity.startDate)
            guard startOfDay >= activityStartDate else { return false }
            
            switch activity.pattern {
            case .fixedDays(let days):
                let weekday = calendar.component(.weekday, from: date)
                return days.contains { $0.rawValue == weekday }
                
            case .interval(let interval):
                let daysSinceStart = calendar.dateComponents([.day], from: activityStartDate, to: startOfDay).day ?? 0
                return daysSinceStart >= 0 && daysSinceStart % interval == 0
            }
        }
    }
    
    private func previousMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    private func nextMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) {
            selectedDate = newDate
        }
    }
}

struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let activities: [SelfCareActivity]
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(.system(size: 18))
                    .fontWeight(isSelected ? .bold : .regular)
                    .frame(height: 25)
                
                // Container for icons with fixed size
                VStack(spacing: 2) {
                    if !activities.isEmpty {
                        let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 3)
                        LazyVGrid(columns: columns, spacing: 2) {
                            ForEach(activities) { activity in
                                Image(systemName: activity.icon)
                                    .foregroundColor(activity.color)
                                    .font(.system(size: 10))
                            }
                        }
                    }
                }
                .frame(height: 35)
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(0.8, contentMode: .fill)
            .padding(6)
            .background(
                Circle()
                    .fill(isSelected ? Color.blue : Color.clear)
                    .opacity(isSelected ? 0.2 : 0)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    let viewModel = SelfCareViewModel()
    viewModel.addActivity(SelfCareActivity(
        name: "Retinol",
        icon: "moon.fill",
        color: .purple,
        pattern: .interval(3),
        startDate: Date()
    ))
    return CalendarView(
        selectedDate: .constant(Date()),
        viewModel: viewModel
    )
} 
