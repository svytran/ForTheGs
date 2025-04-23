import SwiftUI

struct WeeklyView: View {
    let selectedDate: Date
    @ObservedObject var viewModel: SelfCareViewModel
    
    private var datesForSelectedWeek: [Date] {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate))!
        return (0...6).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek)
        }
    }
    
    private func weekdayString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Upcoming this week")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                ForEach(datesForSelectedWeek, id: \.self) { date in
                    let dayActivities = activitiesForDate(date)
                    if !dayActivities.isEmpty {
                        HStack(alignment: .center, spacing: 16) {
                            // Date column
                            VStack(alignment: .leading) {
                                Text(weekdayString(for: date))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("\(Calendar.current.component(.day, from: date))")
                                    .font(.body)
                                    .fontWeight(Calendar.current.isDate(date, inSameDayAs: selectedDate) ? .bold : .regular)
                            }
                            .frame(width: 50, alignment: .leading)
                            
                            // Activities
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(dayActivities) { activity in
                                        HStack(spacing: 4) {
                                            Image(systemName: activity.icon)
                                                .foregroundColor(activity.color)
                                            Text(activity.name)
                                                .font(.subheadline)
                                        }
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(activity.color.opacity(0.1))
                                        )
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }
}
