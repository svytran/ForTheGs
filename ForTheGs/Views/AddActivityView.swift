import SwiftUI

struct AddActivityView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AddActivityViewModel
    
    init(selfCareViewModel: SelfCareViewModel, initialStartDate: Date) {
        _viewModel = StateObject(wrappedValue: AddActivityViewModel(selfCareViewModel: selfCareViewModel, initialStartDate: initialStartDate))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("ACTIVITY DETAILS") {
                    TextField("Activity Name", text: $viewModel.name)
                    
                    NavigationLink {
                        IconPickerView(selectedIcon: $viewModel.selectedIcon)
                    } label: {
                        HStack {
                            Text("Icon")
                            Spacer()
                            Image(systemName: viewModel.selectedIcon)
                        }
                    }
                    
                    ColorPicker("Color", selection: $viewModel.selectedColor)
                }
                
                Section("START DATE") {
                    DatePicker(
                        "Start Date",
                        selection: .constant(viewModel.initialStartDate),
                        displayedComponents: .date
                    )
                    .disabled(true)
                }
                
                Section("RECURRING PATTERN") {
                    Picker("Pattern Type", selection: $viewModel.patternType) {
                        Text("Fixed Days").tag(AddActivityViewModel.PatternType.fixedDays)
                        Text("Every X Days").tag(AddActivityViewModel.PatternType.interval)
                    }
                    .pickerStyle(.segmented)
                    
                    if viewModel.patternType == .fixedDays {
                        ForEach(RecurringPattern.Weekday.allCases, id: \.rawValue) { day in
                            Toggle(viewModel.formatWeekday(day), isOn: Binding(
                                get: { viewModel.selectedDays.contains(day) },
                                set: { isSelected in
                                    viewModel.toggleDay(day)
                                }
                            ))
                        }
                    } else {
                        Stepper(
                            "Every \(viewModel.intervalDays) day\(viewModel.intervalDays == 1 ? "" : "s")",
                            value: $viewModel.intervalDays,
                            in: 1...365
                        )
                    }
                }
            }
            .navigationTitle("New Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.save()
                        dismiss()
                    }
                    .disabled(!viewModel.isValid)
                }
            }
        }
    }
}

#Preview {
    AddActivityView(
        selfCareViewModel: SelfCareViewModel(),
        initialStartDate: Date()
    )
} 