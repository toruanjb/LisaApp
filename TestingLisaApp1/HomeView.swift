//
//  HomeView.swift
//  TestingLisaApp1
//
//  Created by Jeremy Lumban Toruan on 26/03/25.
//
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = ExpenseViewModel()
    @State private var showingAddExpense = false
    @State private var expenseToEdit: Expense? = nil
    @State private var showingEditSheet = false

    var totalSpent: Double {
        return viewModel.expenses.reduce(0) { $0 + $1.amount }
    }
    
    var savedAmount: Double {
        if let budget = viewModel.budget {
            return budget.amount - totalSpent
        }
        return 0
    }

    var body: some View {
        NavigationView {
            VStack {
                // HEADER SECTION
                HeaderView(totalSpent: totalSpent, savedAmount: savedAmount, budget: viewModel.budget)
                
                // LIST OF TRANSACTIONS
                List {
                    ForEach(viewModel.expenses) { expense in
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
                
                Spacer()
                
                // ADD BUTTON
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
            .navigationTitle("Expense Tracker")
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseView(viewModel: viewModel, initialMode: .expense)
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
}

// MARK: - Supporting Views
struct HeaderView: View {
    let totalSpent: Double
    let savedAmount: Double
    let budget: Budget?
    
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
                    // Saved Amount
                    VStack {
                        Text("Saved")
                            .font(.caption)
                        Text("Rp\(Int(savedAmount))")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Budget Display
                    VStack {
                        Text("Budget")
                            .font(.caption)
                        if let budget = budget {
                            VStack {
                                Text("Rp\(Int(budget.amount))")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                    .bold()
                                
//                                if let notes = budget.notes, !notes.isEmpty {
//                                    Text(notes)
//                                        .font(.caption)
//                                        .foregroundColor(.gray)
//                                }
                            }
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
        }
        .padding()
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
            // Icon with fixed size container
            Image(systemName: expense.category.icon)
                .foregroundColor(.blue)
                .font(.title2)
                .frame(width: 40, height: 40)
            
            // Text content with proper vertical alignment
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
            
            // Amount with consistent padding
            Text("-Rp\(Int(expense.amount))")
                .foregroundColor(.red)
        }
        .contentShape(Rectangle()) // Makes the entire row tappable
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
            // Visual feedback when tapped
            isPressed = true
            
            // Small delay before showing the action sheet
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
                showingActionSheet = true
            }
        }
    }
}
#Preview {
    HomeView()
}
