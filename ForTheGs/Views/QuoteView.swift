import SwiftUI

struct QuoteView: View {
    @ObservedObject var viewModel: QuoteViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else if let quote = viewModel.currentQuote {
                ZStack(alignment: .bottomTrailing) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(quote.q)
                            .font(.body)
                            .italic()
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("- \(quote.a)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.trailing, 24) // Make space for refresh button
                    
                    Button(action: {
                        viewModel.fetchRandomQuote()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.pink.opacity(0.8))
                            .font(.system(size: 14))
                    }
                }
                .frame(minHeight: 100)  // Minimum height
                .padding()
                .background(Color.pink.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
            } else if let error = viewModel.error {
                Text("Error loading quote: \(error.localizedDescription)")
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }
} 