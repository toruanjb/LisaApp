//
//  ExpenseViewModel.swift
//  TestingLisaApp1
//
//  Created by Jeremy Lumban Toruan on 26/03/25.
////
//
import SwiftUI

class ExpenseViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    @Published var budget: Budget?
    
    var totalSpentToday: Double {
        expenses.filter { Calendar.current.isDateInToday($0.date) }
               .reduce(0) { $0 + $1.amount }
    }
    
    func addExpense(amount: Double, category: ExpenseCategory, notes: String? = nil) {
        let newExpense = Expense(amount: amount, category: category, date: Date(), notes: notes)
        expenses.append(newExpense)
    }
    
    func updateExpense(id: UUID, amount: Double, category: ExpenseCategory, notes: String? = nil) {
        if let index = expenses.firstIndex(where: { $0.id == id }) {
            // Create an updated expense with the same date as the original
            let originalDate = expenses[index].date
            let updatedExpense = Expense(id: id, amount: amount, category: category, date: originalDate, notes: notes)
            expenses[index] = updatedExpense
        }
    }
    
    func deleteExpense(id: UUID) {
        expenses.removeAll { $0.id == id }
    }
    
    func setBudget(amount: Double, timeframe: Timeframe = .monthly, notes: String? = nil) {
        budget = Budget(amount: amount, timeframe: timeframe)
    }
}


