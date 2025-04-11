//
//  EditExpenseView.swift
//  TestingLisaApp1
//

import SwiftUI


struct EditExpenseView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    let expense: Expense
    
    @State private var amount: String
    @State private var notes: String
    @State private var selectedCategory: ExpenseCategory
    @State private var showCategoryPicker = false
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var isAmountFieldFocused: Bool
    @FocusState private var isNotesFieldFocused: Bool
    @State private var showNotesInput: Bool
    
    init(viewModel: ExpenseViewModel, expense: Expense) {
        self.viewModel = viewModel
        self.expense = expense
        
        // Initialize state variables with existing expense data
        _amount = State(initialValue: String(Int(expense.amount)))
        _notes = State(initialValue: expense.notes ?? "")
        _selectedCategory = State(initialValue: expense.category)
        _showNotesInput = State(initialValue: expense.notes != nil && !expense.notes!.isEmpty)
    }
    
    private var formattedAmount: String {
            guard let intAmount = Int(amount) else { return amount }
            return intAmount.formatWithSeparator()
        }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Edit Expense")
                    .font(.title)
                    .padding()
                
                // Amount Display
                Text("-Rp\(amount.isEmpty ? "0" : amount)")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                    .padding()
                
                // Notes Field
                if showNotesInput {
                    // Notes input field
                    TextField("Enter notes (e.g., KFC, Grocery shopping)", text: $notes)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .focused($isNotesFieldFocused)
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
                    Text(expense.date, style: .date)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
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
                        viewModel.updateExpense(
                            id: expense.id,
                            amount: amountValue,
                            category: selectedCategory,
                            notes: notes.isEmpty ? nil : notes
                        )
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Update Expense")
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .onAppear {
                isAmountFieldFocused = true
            }
        }
    }
}
