//
//  HomeView.swift
//  TestingLisaApp1
//
//  Created by Jeremy Lumban Toruan on 26/03/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel: ExpenseViewModel
    @State private var showingAddExpense = false
    @State private var expenseToEdit: Expense? = nil
    @State private var showingEditSheet = false
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    @State private var dragOffset: CGFloat = 0
    
    var filteredExpenses: [Expense] {
        return viewModel.expenses.filter { expense in
            Calendar.current.isDate(expense.date, inSameDayAs: selectedDate)
        }
    }
    
    var totalSpent: Double {
        return filteredExpenses.reduce(0) { $0 + $1.amount }
    }
    
    var savedAmount: Double {
        if let budget = viewModel.budget {
            return budget.amount - totalSpent
        }
        return 0
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HeaderView(
                    totalSpent: totalSpent,
                    savedAmount: savedAmount,
                    budget: viewModel.budget,
                    selectedDate: $selectedDate,
                    showDatePicker: $showDatePicker
                )
                
                if showDatePicker {
                    DatePicker("Select date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .transition(.opacity)
                }
                
                if filteredExpenses.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "doc.text")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No expenses on \(selectedDate, formatter: dateFormatter)")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(filteredExpenses) { expense in
                            ExpenseRow(
                                expense: expense,
                                onEdit: {
                                    expenseToEdit = expense
                                    showingEditSheet = true
                                },
                                onDelete: {
                                    viewModel.deleteExpense(id: expense.id)
                                }
                            )
                        }
                    }
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    Button(action: {
                        showingAddExpense = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseView(viewModel: viewModel, initialMode: .expense)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showingEditSheet, onDismiss: {
                expenseToEdit = nil
            }) {
                if let expense = expenseToEdit {
                    EditExpenseView(viewModel: viewModel, expense: expense)
                }
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}

struct HeaderView: View {
    let totalSpent: Double
    let savedAmount: Double
    let budget: Budget?
    @Binding var selectedDate: Date
    @Binding var showDatePicker: Bool
    
    var body: some View {
        VStack {
            Text("Manage Your Money!")
                .font(.title)
                .bold()
            
            VStack {
                HStack {
                    Text("Total Spent")
                        .font(.headline)
                    
                    Text("Today")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Text("-Rp\(Int(totalSpent))")
                    .font(.title)
                    .foregroundColor(.red)
                    .bold()
                
                HStack {
                    VStack {
                        Text("Saved")
                            .font(.caption)
                        Text("Rp\(Int(savedAmount))")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text("Budget")
                            .font(.caption)
                        if let budget = budget {
                            Text("Rp\(Int(budget.amount))")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                                .bold()
                        } else {
                            Text("-")
                                .font(.title3)
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
            .padding(.horizontal)
            
            Text("You're on track of your savings goals!")
                .font(.caption)
                .foregroundColor(.gray)
            
            Button(action: {
                withAnimation {
                    showDatePicker.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.blue)
                    
                    Text(selectedDate, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundColor(.blue)
                        .rotationEffect(Angle(degrees: showDatePicker ? 180 : 0))
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.top, 4)
            }
        }
        .padding(.bottom, 8)
    }
}

struct ExpenseRow: View {
    let expense: Expense
    let onEdit: () -> Void
    let onDelete: () -> Void
    @State private var showingActionSheet = false
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: expense.category.icon)
                .foregroundColor(.blue)
                .font(.title2)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(expense.category.rawValue)
                    .font(.headline)
                if let notes = expense.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Text("-Rp\(Int(expense.amount))")
                .foregroundColor(.red)
        }
        .contentShape(Rectangle())
        .background(isPressed ? Color.gray.opacity(0.15) : Color.clear)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .confirmationDialog("Expense Options", isPresented: $showingActionSheet, titleVisibility: .visible) {
            Button("Edit") {
                onEdit()
            }
            Button("Delete", role: .destructive) {
                onDelete()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("What would you like to do with this expense?")
        }
        .onTapGesture {
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
                showingActionSheet = true
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(ExpenseViewModel())
}