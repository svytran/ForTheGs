import SwiftUI

struct IconPickerView: View {
    @Binding var selectedIcon: String
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = IconPickerViewModel()
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.pink.opacity(0.3),
                    Color.white
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            // Content
            List {
                ForEach(viewModel.icons, id: \.self) { icon in
                    Button {
                        selectedIcon = icon
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: icon)
                                .foregroundColor(.primary)
                                .font(.title2)
                            Spacer()
                            if icon == selectedIcon {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color.pink.opacity(0.8))
                            }
                        }
                    }
                    .listRowBackground(Color.white)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Choose Icon")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                }
            }
        }
        .toolbarBackground(Color.pink.opacity(0.2), for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        IconPickerView(selectedIcon: .constant("heart.fill"))
    }
} 
