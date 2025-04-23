import Foundation

struct Quote: Codable {
    let q: String
    let a: String
    
    enum CodingKeys: String, CodingKey {
        case q // quote text
        case a // author
    }
}

class QuoteViewModel: ObservableObject {
    @Published var currentQuote: Quote?
    @Published var isLoading = false
    @Published var error: Error?
    
    private let baseURL = "https://zenquotes.io/api"
    
    func fetchRandomQuote() {
        isLoading = true
        error = nil
        
        guard let url = URL(string: "\(baseURL)/random") else {
            error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    print("Network error: \(error.localizedDescription)")
                    self?.error = error
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                }
                
                guard let data = data else {
                    self?.error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                    return
                }
                
                do {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Received JSON: \(jsonString)")
                    }
                    
                    let quotes = try JSONDecoder().decode([Quote].self, from: data)
                    self?.currentQuote = quotes.first
                } catch {
                    print("Decoding error: \(error)")
                    self?.error = error
                }
            }
        }.resume()
    }
} 