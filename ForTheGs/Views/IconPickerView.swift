import SwiftUI

struct IconPickerView: View {
    @Binding var selectedIcon: String
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = IconPickerViewModel()
    
    var body: some View {
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
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .navigationTitle("Choose Icon")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        IconPickerView(selectedIcon: .constant("heart.fill"))
    }
} 