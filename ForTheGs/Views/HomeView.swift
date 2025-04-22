import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: SelfCareViewModel
    @State private var completedActivities: Set<UUID> = []
    
    init(viewModel: SelfCareViewModel) {
        self.viewModel = viewModel
    }
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter
    }()
    
    private var todayActivities: [SelfCareActivity] {
        viewModel.getActivities(for: Date())
    }
    
    private var todoActivities: [SelfCareActivity] {
        todayActivities.filter { !completedActivities.contains($0.id) }
    }
    
    private var doneActivities: [SelfCareActivity] {
        todayActivities.filter { completedActivities.contains($0.id) }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // Week view
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(-1...5, id: \.self) { dayOffset in
                        if let date = Calendar.current.date(byAdding: .day, value: dayOffset, to: Date()) {
                            DayButton(date: date, isToday: dayOffset == 0)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top)
            // Today's date header
            VStack(alignment: .leading, spacing: 4) {
                Text("Today.")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text(dateFormatter.string(from: Date()))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            // To Do Section
            if !todoActivities.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("To Do")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                    
                    ForEach(todoActivities) { activity in
                        ActivityRow(
                            activity: activity,
                            isCompleted: false
                        ) {
                            completedActivities.insert(activity.id)
                        }
                    }
                }
            }
            
            // Done Section
            if !doneActivities.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Done")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                    
                    ForEach(doneActivities) { activity in
                        ActivityRow(
                            activity: activity,
                            isCompleted: true
                        ) {
                            completedActivities.remove(activity.id)
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding(.top)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.pink.opacity(0.1),
                    Color.white
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
        )
    }
}

private struct DayButton: View {
    let date: Date
    let isToday: Bool
    
    private var day: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private var weekday: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack {
            Text(weekday)
                .font(.caption)
                .foregroundColor(.gray)
            Text(day)
                .font(.body)
                .fontWeight(.medium)
        }
        .frame(width: 50, height: 50)
        .background(isToday ? Color.pink.opacity(0.3) : Color.pink.opacity(0.6))
        .cornerRadius(12)
    }
}

private struct ActivityRow: View {
    let activity: SelfCareActivity
    let isCompleted: Bool
    let onToggle: () -> Void
    
    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Image(systemName: activity.icon)
                    .foregroundColor(activity.color)
                Text(activity.name)
                    .strikethrough(isCompleted)
            }
            Spacer()
            Button(action: onToggle) {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isCompleted ? .green : .gray)
            }
        }
        .padding()
        .background(activity.color.opacity(0.2))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview("Home") {
    let viewModel = SelfCareViewModel()
    viewModel.addActivity(SelfCareActivity(
        name: "Drink Water",
        icon: "drop.fill",
        color: .blue,
        pattern: .fixedDays([.monday, .wednesday, .friday]),
        startDate: Date()
    ))
    viewModel.addActivity(SelfCareActivity(
        name: "Meditate",
        icon: "heart.fill",
        color: .purple,
        pattern: .fixedDays([RecurringPattern.Weekday.monday, .wednesday, .friday]),
        startDate: Date()
    ))
    return NavigationStack {
        HomeView(viewModel: viewModel)
    }
} 
