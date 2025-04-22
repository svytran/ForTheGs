import SwiftUI

struct ActivityListView: View {
    let activities: [SelfCareActivity]
    
    var body: some View {
        List {
            ForEach(activities) { activity in
                HStack {
                    Image(systemName: activity.icon)
                        .foregroundColor(activity.color)
                    Text(activity.name)
                }
            }
        }
    }
}

#Preview {
    ActivityListView(activities: [])
} 
