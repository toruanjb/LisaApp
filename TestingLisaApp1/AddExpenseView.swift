//
//  AddExpenseView.swift
//  TestingLisaApp1
//
//  Created by Jeremy Lumban Toruan on 26/03/25.
//

import SwiftUI

struct AddExpenseView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @State private var amount: String = ""
    @State private var notes: String = ""
    @State private var selectedCategory: ExpenseCategory = .food // Default value
    @State private var selectedMode: EntryMode
    @State private var showNotesInput = false
    @State private var showCategoryPicker = false
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var isAmountFieldFocused: Bool
    @FocusState private var isNotesFieldFocused: Bool
    
    enum EntryMode {
        case expense
        case budget
    }
    
    init(viewModel: ExpenseViewModel, initialMode: EntryMode = .expense) {
        self.viewModel = viewModel
        _selectedMode = State(initialValue: initialMode)
    }
    
    private var formattedAmount: String {
            guard let intAmount = Int(amount) else { return amount }
            return intAmount.formatWithSeparator()
        }
    
    var body: some View {
        NavigationView {
            VStack {
                // Mode Selector
                HStack {
                    Text("Expense")
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(selectedMode == .expense ? Color.blue : Color.clear)
                        .foregroundColor(selectedMode == .expense ? .white : .blue)
                        .cornerRadius(10)
                        .onTapGesture {
                            selectedMode = .expense
                        }
                    
                    Text("Budget")
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(selectedMode == .budget ? Color.blue : Color.clear)
                        .foregroundColor(selectedMode == .budget ? .white : .blue)
                        .cornerRadius(10)
                        .onTapGesture {
                            selectedMode = .budget
                        }
                }
                .padding()
                
                // Amount Display
                                if selectedMode == .expense {
                                    Text("-Rp\(formattedAmount.isEmpty ? "0" : formattedAmount)")
                                        .font(.largeTitle)
                                        .foregroundColor(.red)
                                        .padding()
                                } else {
                                    // Use blue color for budget amount
                                    Text("Rp\(formattedAmount.isEmpty ? "0" : formattedAmount)")
                                        .font(.largeTitle)
                                        .foregroundColor(.blue)
                                        .padding()
                                }

                
                // Add Notes Button/Field
                if showNotesInput {
                    // Notes input field
                    TextField("Enter notes (e.g., KFC, Grocery shopping)", text: $notes)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .focused($isNotesFieldFocused)
                        .onAppear {
                            isNotesFieldFocused = true
                        }
                } else {
                    // Add Notes Button
                    Button(action: {
                        showNotesInput = true
                    }) {
                        HStack {
                            Text("Add Notes")
                                .foregroundColor(.gray)
                            
                            if !notes.isEmpty {
                                Text("(\(notes))")
                                    .foregroundColor(.blue)
                                    .italic()
                            }
                        }
                    }
                    .padding()
                }
                
                // Date and Category
                HStack {
                    Text(Date(), style: .date)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    if selectedMode == .expense {
                        Button(action: {
                            showCategoryPicker = true
                        }) {
                            HStack {
                                Image(systemName: selectedCategory.icon)
                                    .foregroundColor(.blue)
                                Text(selectedCategory.rawValue)
                                    .foregroundColor(.blue)
                                
                                // Add a small chevron to indicate it's clickable
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                .padding()
                
                // Direct Amount Input
                TextField("", text: $amount)
                    .keyboardType(.numberPad)
                    .opacity(0)
                    .frame(width: 0, height: 0)
                    .focused($isAmountFieldFocused)
                
                // Save Button
                Button(action: {
                    if let amountValue = Double(amount) {
                        switch selectedMode {
                        case .expense:
                            viewModel.addExpense(
                                amount: amountValue,
                                category: selectedCategory,
                                notes: notes.isEmpty ? nil : notes
                            )
                            presentationMode.wrappedValue.dismiss()
                        case .budget:
                            viewModel.setBudget(amount: amountValue)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }) {
                    Text(selectedMode == .expense ? "Save Expense" : "Save Budget")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                }
                .disabled(amount.isEmpty)
            }
            .sheet(isPresented: $showCategoryPicker) {
                CategoryPickerView(selectedCategory: $selectedCategory, isPresented: $showCategoryPicker)
            }
            .onAppear {
                isAmountFieldFocused = true
            }
        }
    }
}

extension Int {
    func formatWithSeparator() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.groupingSize = 3
        
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

struct CategoryPickerView: View {
    @Binding var selectedCategory: ExpenseCategory
    @Binding var isPresented: Bool
    @State private var tempSelection: ExpenseCategory
    
    init(selectedCategory: Binding<ExpenseCategory>, isPresented: Binding<Bool>) {
        self._selectedCategory = selectedCategory
        self._isPresented = isPresented
        self._tempSelection = State(initialValue: selectedCategory.wrappedValue)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    isPresented = false
                }
                
                Spacer()
                
                Button("Done") {
                    selectedCategory = tempSelection
                    isPresented = false
                }
            }
            .padding()
            
            Picker("Category", selection: $tempSelection) {
                ForEach(ExpenseCategory.allCases, id: \.self) { category in
                    HStack {
                        Image(systemName: category.icon)
                        Text(category.rawValue)
                    }
                    .tag(category)
                }
            }
            .pickerStyle(.wheel)
            .labelsHidden()
            
            Spacer()
        }
        .presentationDetents([.height(250)])
    }
}



