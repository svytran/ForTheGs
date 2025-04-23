import Foundation

@MainActor
class HealthArticlesViewModel: ObservableObject {
    @Published var articles: [HealthArticle] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let service = HealthArticleService()
    
    func fetchArticles() {
        isLoading = true
        error = nil
        print("Starting to fetch articles...")
        
        Task {
            do {
                print("Making API request...")
                articles = try await service.fetchHealthArticles()
                print("Successfully fetched \(articles.count) articles")
            } catch {
                print("Error fetching articles: \(error.localizedDescription)")
                self.error = error
            }
            isLoading = false
        }
    }
} 