// import SwiftUI

// struct TrackersView: View {
//     @StateObject private var viewModel: TrackersViewModel
    
//     init(repository: SelfCareActivityRepositoryProtocol) {
//         _viewModel = StateObject(wrappedValue: TrackersViewModel(repository: repository))
//     }
    
//     var body: some View {
//         List {
//             ForEach(viewModel.activities) { activity in
//                 TrackerRow(
//                     activity: activity,
//                     isCompleted: viewModel.isCompleted(activity),
//                     onToggle: { viewModel.toggleCompletion(for: activity.id) }
//                 )
//             }
//             .onDelete { indexSet in
//                 indexSet.forEach { index in
//                     viewModel.deleteActivity(viewModel.activities[index])
//                 }
//             }
//         }
//         .navigationTitle("Your Trackers")
//         .scrollContentBackground(.hidden)
//         .background(
//             LinearGradient(
//                 gradient: Gradient(colors: [
//                     Color.pink.opacity(0.2),
//                     Color.white
//                 ]),
//                 startPoint: .top,
//                 endPoint: .bottom
//             )
//             .edgesIgnoringSafeArea(.all)
//         )
//     }
// }

// // MARK: - Supporting Views
// private struct TrackerRow: View {
//     let activity: SelfCareActivity
//     let isCompleted: Bool
//     let onToggle: () -> Void
    
//     var body: some View {
//         HStack {
//             Image(systemName: activity.icon)
//                 .foregroundColor(activity.color)
            
//             VStack(alignment: .leading) {
//                 Text(activity.name)
//                     .strikethrough(isCompleted)
                
//                 if let description = activity.description {
//                     Text(description)
//                         .font(.caption)
//                         .foregroundColor(.gray)
//                 }
//             }
            
//             Spacer()
            
//             Button(action: onToggle) {
//                 Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
//                     .foregroundColor(isCompleted ? .green : .gray)
//             }
//         }
//         .padding(.vertical, 4)
//         .listRowBackground(Color.clear)
//     }
// }

// #Preview {
//     NavigationStack {
//         DescriptionsView(viewModel: SelfCareViewModel())
//     }
// } 
