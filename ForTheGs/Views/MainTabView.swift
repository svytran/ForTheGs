import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = SelfCareViewModel()
    @State private var selectedTab = Tab.home
    @State private var showingAddActivity = false
    
    enum Tab {
        case home
        case calendar
        case add
        case tasks
        case settings
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeView(viewModel: viewModel)
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(Tab.home)
            
            NavigationStack {
                CalendarView(
                    selectedDate: $viewModel.selectedDate,
                    activities: viewModel.activities
                )
                .navigationTitle("Self Care Tracker")
            }
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }
            .tag(Tab.calendar)
            
            Color.clear
                .tabItem {
                    Label("", systemImage: "")
                }
                .tag(Tab.add)
            
            NavigationStack {
                TasksView(viewModel: viewModel)
            }
            .tabItem {
                Label("Tasks", systemImage: "checklist")
            }
            .tag(Tab.tasks)
            
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(Tab.settings)
        }
        .overlay(alignment: .bottom) {
            // Floating Add Button
            Button {
                showingAddActivity = true
            } label: {
                ZStack {
                    Circle()
                        .fill(.white)
                        .shadow(color: .black.opacity(0.2), radius: 4)
                        .frame(width: 70, height: 70)
                    
                    Circle()
                        .fill(Color.green.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.green)
                }
            }
            .offset(y: -40)
        }
        .sheet(isPresented: $showingAddActivity) {
            AddActivityView(
                selfCareViewModel: viewModel,
                initialStartDate: viewModel.selectedDate
            )
        }
        .onChange(of: selectedTab) { oldValue, newValue in
            if newValue == .add {
                showingAddActivity = true
                selectedTab = oldValue
            }
        }
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings View")
            .navigationTitle("Settings")
    }
}

#Preview {
    MainTabView()
} 