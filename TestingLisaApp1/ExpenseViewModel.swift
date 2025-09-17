//
//  ExpenseViewModel.swift
//  TestingLisaApp1
//
//  Created by Jeremy Lumban Toruan on 26/03/25.
//

import SwiftUI

class ExpenseViewModel: ObservableObject {
    @Published var expenses: [Expense] = [] {
        didSet {
            saveExpenses()
        }
    }
    @Published var budget: Budget? {
        didSet {
            saveBudget()
        }
    }
    
    private let expensesKey = "SavedExpenses"
    private let budgetKey = "SavedBudget"
    
    init() {
        loadExpenses()
        loadBudget()
    }
    
    var totalSpentToday: Double {
        expenses.filter { Calendar.current.isDateInToday($0.date) }
               .reduce(0) { $0 + $1.amount }
    }
    
    func addExpense(amount: Double, category: ExpenseCategory, notes: String? = nil, date: Date = Date()) {
        let newExpense = Expense(amount: amount, category: category, date: date, notes: notes)
        expenses.append(newExpense)
    }
    
    func updateExpense(id: UUID, amount: Double, category: ExpenseCategory, notes: String? = nil, date: Date? = nil) {
        if let index = expenses.firstIndex(where: { $0.id == id }) {
            let expenseDate = date ?? expenses[index].date
            let updatedExpense = Expense(id: id, amount: amount, category: category, date: expenseDate, notes: notes)
            expenses[index] = updatedExpense
        }
    }
    
    func deleteExpense(id: UUID) {
        expenses.removeAll { $0.id == id }
    }
    
    func setBudget(amount: Double, timeframe: Timeframe = .monthly, notes: String? = nil) {
        budget = Budget(amount: amount, timeframe: timeframe)
    }
    
    // MARK: - Persistence Methods
    private func saveExpenses() {
        if let encoded = try? JSONEncoder().encode(expenses) {
            UserDefaults.standard.set(encoded, forKey: expensesKey)
        }
    }
    
    private func loadExpenses() {
        if let data = UserDefaults.standard.data(forKey: expensesKey),
           let decoded = try? JSONDecoder().decode([Expense].self, from: data) {
            expenses = decoded
        }
    }
    
    private func saveBudget() {
        if let budget = budget, let encoded = try? JSONEncoder().encode(budget) {
            UserDefaults.standard.set(encoded, forKey: budgetKey)
        } else {
            UserDefaults.standard.removeObject(forKey: budgetKey)
        }
    }
    
    private func loadBudget() {
        if let data = UserDefaults.standard.data(forKey: budgetKey),
           let decoded = try? JSONDecoder().decode(Budget.self, from: data) {
            budget = decoded
        }
    }
}
