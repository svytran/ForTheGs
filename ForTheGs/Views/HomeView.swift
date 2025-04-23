import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: SelfCareViewModel
    @StateObject private var quoteViewModel = QuoteViewModel()
    @StateObject private var healthArticlesViewModel = HealthArticlesViewModel()
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
        ScrollView {
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
                
                // Quote Section
                QuoteView(viewModel: quoteViewModel)
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
                // Health Articles Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Take a Moment")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                        .padding(.top, 24)
                    
                    if healthArticlesViewModel.isLoading {
                        ProgressView("Loading articles...")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else if let error = healthArticlesViewModel.error {
                        VStack(spacing: 8) {
                            Text("Error loading articles")
                                .foregroundColor(.red)
                            Text(error.localizedDescription)
                                .font(.caption)
                            Button("Try Again") {
                                healthArticlesViewModel.fetchArticles()
                            }
                            .buttonStyle(.bordered)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                    } else if healthArticlesViewModel.articles.isEmpty {
                        Text("No articles available")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(healthArticlesViewModel.articles.prefix(5)) { article in
                                    ArticleCard(article: article)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom)
            }
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
        .onAppear {
            quoteViewModel.fetchRandomQuote()
            healthArticlesViewModel.fetchArticles()
        }
    }
}

private struct ArticleCard: View {
    let article: HealthArticle
    @Environment(\.openURL) private var openURL
    @State private var isPressed = false
    
    var body: some View {
        Button {
            if let url = URL(string: article.link) {
                openURL(url)
            }
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                if let imageUrl = article.imageUrl,
                   let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                    }
                    .frame(width: 240, height: 140)
                    .clipped()
                    .cornerRadius(12)
                }
                
                Text(article.title)
                    .font(.headline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                
                if let description = article.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                HStack {
                    if let source = article.source {
                        Text(source)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                        .foregroundColor(.pink.opacity(0.8))
                        .font(.caption)
                }
            }
            .frame(width: 240)
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: isPressed ? 2 : 4)
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isPressed)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
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
