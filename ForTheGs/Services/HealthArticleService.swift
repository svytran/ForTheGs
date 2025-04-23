import Foundation

class HealthArticleService {
    private let apiKey = "pub_824566ec348e47c945af7a8363b9cb8198836"
    private let baseURL = "https://newsdata.io/api/1/news"
    
    func fetchHealthArticles() async throws -> [HealthArticle] {
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "q", value: "women health wellness"),
            URLQueryItem(name: "language", value: "en"),
            URLQueryItem(name: "category", value: "health")
        ]
        
        guard let url = urlComponents.url else {
            print("Error: Invalid URL")
            throw URLError(.badURL)
        }
        
        print("Requesting URL: \(url)")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Error: Not an HTTP response")
            throw URLError(.badServerResponse)
        }
        
        print("Response status code: \(httpResponse.statusCode)")
        
        if httpResponse.statusCode != 200 {
            let responseString = String(data: data, encoding: .utf8) ?? "No response body"
            print("Error response: \(responseString)")
            throw URLError(.badServerResponse)
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let articleResponse = try decoder.decode(HealthArticleResponse.self, from: data)
            print("Decoded response with \(articleResponse.results.count) articles")
            return articleResponse.results
        } catch {
            print("Decoding error: \(error)")
            let responseString = String(data: data, encoding: .utf8) ?? "No response body"
            print("Raw response: \(responseString)")
            throw error
        }
    }
} 