import SwiftUI

struct DescriptionsView: View {
    @ObservedObject var viewModel: SelfCareViewModel
    @State private var completedActivities: Set<UUID> = []
    
    var body: some View {
        List {
            ForEach(viewModel.getActivities(for: Date())) { activity in
                HStack {
                    Image(systemName: activity.icon)
                        .foregroundColor(activity.color)
                    
                    Text(activity.name)
                        .strikethrough(completedActivities.contains(activity.id))
                    
                    Spacer()
                    
                    Button {
                        if completedActivities.contains(activity.id) {
                            completedActivities.remove(activity.id)
                        } else {
                            completedActivities.insert(activity.id)
                        }
                    } label: {
                        Image(systemName: completedActivities.contains(activity.id) ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(completedActivities.contains(activity.id) ? .green : .gray)
                    }
                }
                .padding(.vertical, 4)
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle("Your Trackers")
        .scrollContentBackground(.hidden)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.pink.opacity(0.2),
                    Color.white
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
        )
    }
}

#Preview {
    NavigationStack {
        DescriptionsView(viewModel: SelfCareViewModel())
    }
} 
