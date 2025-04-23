import SwiftUI

struct DescriptionsView: View {
    @ObservedObject var viewModel: SelfCareViewModel
    @State private var expandedId: UUID?
    @State private var showingEditSheet = false
    @State private var selectedActivity: SelfCareActivity?
    @State private var showingDeleteAlert = false
    @State private var activityToDelete: SelfCareActivity?
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color.pink.opacity(0.1), Color.white],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Title
                Text("Your Trackers")
                    .font(.title3)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.clear)
                
                // Content
                if viewModel.activities.isEmpty {
                    VStack(spacing: 12) {
                        Spacer()
                        Text("No trackers yet")
                            .font(.body)
                            .foregroundColor(.gray)
                        Text("Add a new tracker using the + button")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.activities) { activity in
                                AccordionItem(
                                    activity: activity,
                                    isExpanded: expandedId == activity.id,
                                    onTap: {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                            expandedId = expandedId == activity.id ? nil : activity.id
                                        }
                                    },
                                    onEdit: {
                                        selectedActivity = activity
                                        showingEditSheet = true
                                    },
                                    onDelete: {
                                        activityToDelete = activity
                                        showingDeleteAlert = true
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingEditSheet, onDismiss: {
            selectedActivity = nil
        }) {
            if let activity = selectedActivity {
                NavigationStack {
                    AddActivityView(
                        selfCareViewModel: viewModel,
                        initialStartDate: activity.startDate,
                        editingActivity: activity
                    )
                }
            }
        }
        .alert("Delete Tracker", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {
                activityToDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let activity = activityToDelete {
                    withAnimation {
                        viewModel.deleteActivity(activity)
                    }
                }
                activityToDelete = nil
            }
        } message: {
            Text("Are you sure you want to delete this tracker? This action cannot be undone.")
        }
    }
}

struct AccordionItem: View {
    let activity: SelfCareActivity
    let isExpanded: Bool
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack {
                HStack(spacing: 16) {
                    // Icon with colored background
                    ZStack {
                        Circle()
                            .fill(activity.color.opacity(0.15))
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: activity.icon)
                            .font(.system(size: 20))
                            .foregroundColor(activity.color)
                    }
                    
                    Text(activity.name)
                        .font(.body)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        if isExpanded {
                            Button(action: onEdit) {
                                Image(systemName: "pencil")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                            
                            Button(action: onDelete) {
                                Image(systemName: "trash")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.red)
                            }
                        }
                        
                        Button(action: onTap) {
                            Image(systemName: "chevron.down")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                                .rotationEffect(.degrees(isExpanded ? -180 : 0))
                        }
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(Color.white)
                .cornerRadius(isExpanded ? 12 : 16)
            }
            
            // Expanded Content
            if isExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    // Schedule Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Schedule")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        switch activity.pattern {
                        case .fixedDays(let days):
                            Text("Every \(days.map { $0.description }.joined(separator: ", "))")
                                .font(.body)
                        case .interval(let interval):
                            Text("Every \(interval) day\(interval == 1 ? "" : "s")")
                                .font(.body)
                        }
                    }
                    
                    // Description Section
                    if let description = activity.activityDescription {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(description)
                                .font(.body)
                        }
                    }
                    
                    // Start Date
                    Text("Started on \(activity.startDate.formatted(date: .long, time: .omitted))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(12)
            }
        }
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}
