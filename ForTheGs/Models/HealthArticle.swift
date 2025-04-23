import Foundation

struct HealthArticle: Codable, Identifiable {
    let id = UUID()
    let title: String
    let description: String?
    let link: String
    let source: String?
    let pubDate: String
    let imageUrl: String?
    let content: String?
    let country: [String]?
    let category: [String]?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case link
        case source = "source_id"
        case pubDate
        case imageUrl = "image_url"
        case content
        case country
        case category
    }
}

struct HealthArticleResponse: Codable {
    let status: String
    let totalResults: Int
    let results: [HealthArticle]
    let nextPage: String?
} 