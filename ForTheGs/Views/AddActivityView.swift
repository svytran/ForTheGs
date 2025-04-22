import SwiftUI

struct AddActivityView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AddActivityViewModel
    
    init(selfCareViewModel: SelfCareViewModel, initialStartDate: Date, editingActivity: SelfCareActivity? = nil) {
        _viewModel = StateObject(wrappedValue: AddActivityViewModel(
            selfCareViewModel: selfCareViewModel,
            initialStartDate: initialStartDate,
            editingActivity: editingActivity
        ))
        
        // Customize toggle appearance
        UISwitch.appearance().onTintColor = UIColor(Color.pink.opacity(0.6))
        UISwitch.appearance().thumbTintColor = UIColor.white
    }
    
    var body: some View {
        NavigationStack {
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
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            // Name Section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Name")
                                    .font(.headline)
                                TextField("", text: $viewModel.name)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                            }
                            .padding(.horizontal)
                            
                            // Description Section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Notes")
                                    .font(.headline)
                                ZStack(alignment: .topLeading) {
                                    TextEditor(text: $viewModel.description)
                                        .frame(minHeight: 100)
                                        .scrollContentBackground(.hidden)
                                        .background(Color.white)
                                        .padding(8)
                                        .background(Color.white)
                                        .cornerRadius(8)
                                    
                                    if viewModel.description.isEmpty {
                                        Text("Optional")
                                            .foregroundColor(.gray)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 16)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
                            // Icon & Color Section
                            VStack(alignment: .leading, spacing: 16) {
                                HStack(spacing: 20) {
                                    // Icon Selector
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Icon")
                                            .foregroundColor(.black)
                                            .font(.headline)
                                        NavigationLink {
                                            IconPickerView(selectedIcon: $viewModel.selectedIcon)
                                        } label: {
                                            Image(systemName: viewModel.selectedIcon)
                                                .font(.title)
                                                .foregroundColor(.primary)
                                                .frame(width: 60, height: 60)
                                                .background(Color.white)
                                                .cornerRadius(12)
                                        }
                                    }
                                    
                                    // Color Selector
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Color")
                                            .foregroundColor(.black)
                                            .font(.headline)
                                        ColorPicker("", selection: $viewModel.selectedColor)
                                            .labelsHidden()
                                            .frame(width: 60, height: 60)
                                            .background(Color.white)
                                            .cornerRadius(12)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            // Scheduling Section
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Scheduling")
                                    .font(.headline)
                                    .padding(.horizontal)
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    // Start Date
                                    DatePicker(
                                        "Start Date",
                                        selection: .constant(viewModel.initialStartDate),
                                        displayedComponents: .date
                                    )
                                    .disabled(true)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    
                                    // Pattern Type Selector
                                    Picker("Pattern Type", selection: $viewModel.patternType) {
                                        Text("Fixed Days").tag(AddActivityViewModel.PatternType.fixedDays)
                                        Text("Every X Days").tag(AddActivityViewModel.PatternType.interval)
                                    }
                                    .pickerStyle(.segmented)
                                    .padding(8)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    
                                    if viewModel.patternType == .fixedDays {
                                        // Weekday Selectors
                                        VStack(alignment: .leading, spacing: 8) {
                                            ForEach(RecurringPattern.Weekday.allCases, id: \.rawValue) { day in
                                                Toggle(viewModel.formatWeekday(day), isOn: Binding(
                                                    get: { viewModel.selectedDays.contains(day) },
                                                    set: { isSelected in
                                                        viewModel.toggleDay(day)
                                                    }
                                                ))
                                                .tint(Color.pink.opacity(0.6))
                                                .padding(.vertical, 4)
                                            }
                                        }
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(8)
                                    } else {
                                        // Interval Day Selector
                                        HStack {
                                            Text("Repeat every")
                                            Stepper(
                                                "\(viewModel.intervalDays) day\(viewModel.intervalDays == 1 ? "" : "s")",
                                                value: $viewModel.intervalDays,
                                                in: 1...365
                                            )
                                            .tint(Color.pink.opacity(0.6))
                                        }
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(8)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 100) // Extra padding for the Create Tracker button
                    }
                    
                    // Create/Update Tracker Button
                    Button(action: {
                        viewModel.save()
                        dismiss()
                    }) {
                        Text(viewModel.editingActivity != nil ? "Update Tracker" : "Create Tracker")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(viewModel.isValid ? Color.pink.opacity(0.6) : Color.pink.opacity(0.3))
                            )
                            .padding()
                    }
                    .disabled(!viewModel.isValid)
                }
            }
            .navigationTitle(viewModel.editingActivity != nil ? "Edit Tracker" : "New Tracker")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                    }
                }
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: viewModel.selectedIcon)
                        Text(viewModel.name.isEmpty ? (viewModel.editingActivity != nil ? "Edit Tracker" : "New Tracker") : viewModel.name)
                    }
                    .font(.headline)
                }
            }
            .toolbarBackground(Color.pink.opacity(0.2), for: .navigationBar)
        }
    }
}

#Preview {
    AddActivityView(
        selfCareViewModel: SelfCareViewModel(),
        initialStartDate: Date()
    )
} 
