import SwiftUI

struct HealthArticlesView: View {
    @StateObject private var viewModel = HealthArticlesViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading articles...")
                } else if let error = viewModel.error {
                    VStack(spacing: 16) {
                        Text("Error loading articles")
                            .foregroundColor(.red)
                        Text(error.localizedDescription)
                            .font(.caption)
                        Button("Try Again") {
                            viewModel.fetchArticles()
                        }
                        .buttonStyle(.bordered)
                    }
                } else if viewModel.articles.isEmpty {
                    VStack(spacing: 16) {
                        Text("No articles found")
                            .foregroundColor(.secondary)
                        Button("Refresh") {
                            viewModel.fetchArticles()
                        }
                        .buttonStyle(.bordered)
                    }
                } else {
                    List(viewModel.articles) { article in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(article.title)
                                .font(.headline)
                            if let description = article.description {
                                Text(description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            if let source = article.source {
                                Text("Source: \(source)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Text("Published: \(article.pubDate)")
                                .font(.caption2)
                                .foregroundColor(.gray)
                            if let imageUrl = article.imageUrl {
                                AsyncImage(url: URL(string: imageUrl)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 200)
                                        .clipped()
                                } placeholder: {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(height: 200)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Health Articles")
        }
        .onAppear {
            if viewModel.articles.isEmpty {
                viewModel.fetchArticles()
            }
        }
    }
} 