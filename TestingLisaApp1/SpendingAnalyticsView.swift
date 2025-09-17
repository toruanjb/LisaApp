////
////  SpendingAnalyticsView.swift
////  TestingLisaApp1
////
////  Created by Jeremy Lumban Toruan on 14/04/25.
////
//
//import SwiftUI
//
//struct SpendingAnalyticsView: View {
//    
//    @ObservedObject var viewModel: ExpenseViewModel
//    @State private var selectedTimeframe: Timeframe = .monthly
//    
//    var body: some View {
//        VStack {
//            // Timeframe selector
//            Picker("Timeframe", selection: $selectedTimeframe) {
//                ForEach(Timeframe.allCases, id: \.self) { timeframe in
//                    Text(timeframe.rawValue).tag(timeframe)
//                }
//            }
//            .pickerStyle(SegmentedPickerStyle())
//            .padding()
//            
//            // Category breakdown chart
//            categoryBreakdownChart
//            
//            // Daily spending chart
//            dailySpendingChart
//            
//            // Top expenses
//            topExpensesList
//        }
//        .navigationTitle("Spending Analytics")
//    }
//    
//    private var categoryBreakdownChart: some View {
//        // Implementation for a pie chart showing spending by category
//        let categoryData = getCategoryData()
//        return VStack {
//            Text("Spending by Category")
//                .font(.headline)
//            // Here you would add your chart component
//            // A placeholder for now:
//            ForEach(categoryData, id: \.category) { item in
//                HStack {
//                    Circle()
//                        .fill(categoryColor(for: item.category))
//                        .frame(width: 10, height: 10)
//                    Text(item.category.rawValue)
//                    Spacer()
//                    Text("Rp\(Int(item.amount))")
//                    Text("\(Int(item.percentage))%")
//                }
//                .padding(.horizontal)
//            }
//        }
//        .padding()
//        .background(Color(.systemGray6))
//        .cornerRadius(10)
//        .padding()
//    }
//    
//    private var dailySpendingChart: some View {
//        // Implementation for line chart showing daily spending
//        return VStack {
//            Text("Daily Spending")
//                .font(.headline)
//            // Chart would go here
//        }
//        .padding()
//        .background(Color(.systemGray6))
//        .cornerRadius(10)
//        .padding(.horizontal)
//    }
//    
//    private var topExpensesList: some View {
//        // Implementation for listing top expenses
//        let topExpenses = getTopExpenses(limit: 5)
//        return VStack(alignment: .leading) {
//            Text("Top Expenses")
//                .font(.headline)
//                .padding(.bottom, 5)
//            
//            ForEach(topExpenses) { expense in
//                HStack {
//                    Text(expense.notes ?? expense.category.rawValue)
//                    Spacer()
//                    Text("-Rp\(Int(expense.amount))")
//                        .foregroundColor(.red)
//                }
//                .padding(.vertical, 5)
//            }
//        }
//        .padding()
//        .background(Color(.systemGray6))
//        .cornerRadius(10)
//        .padding(.horizontal)
//    }
//    
//    // Helper methods
//    private func getCategoryData() -> [(category: ExpenseCategory, amount: Double, percentage: Double)] {
//        // Implementation to calculate category data
//        var result: [(category: ExpenseCategory, amount: Double, percentage: Double)] = []
//        let filteredExpenses = getFilteredExpenses()
//        let total = filteredExpenses.reduce(0) { $0 + $1.amount }
//        
//        for category in ExpenseCategory.allCases {
//            let categoryTotal = filteredExpenses
//                .filter { $0.category == category }
//                .reduce(0) { $0 + $1.amount }
//            
//            if categoryTotal > 0 {
//                let percentage = (categoryTotal / total) * 100
//                result.append((category, categoryTotal, percentage))
//            }
//        }
//        
//        return result.sorted { $0.amount > $1.amount }
//    }
//    
//    private func getTopExpenses(limit: Int) -> [Expense] {
//        return getFilteredExpenses()
//            .sorted { $0.amount > $1.amount }
//            .prefix(limit)
//            .map { $0 }
//    }
//    
//    private func getFilteredExpenses() -> [Expense] {
//        let calendar = Calendar.current
//        let now = Date()
//        
//        switch selectedTimeframe {
//        case .daily:
//            return viewModel.expenses.filter { calendar.isDateInToday($0.date) }
//        case .weekly:
//            let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
//            return viewModel.expenses.filter { $0.date >= weekStart }
//        case .monthly:
//            let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
//            return viewModel.expenses.filter { $0.date >= monthStart }
//        }
//    }
//    
//    private func categoryColor(for category: ExpenseCategory) -> Color {
//        switch category {
//        case .food: return .blue
//        case .transportation: return .green
//        case .clothes: return .orange
//        }
//    }
//}
//


//
//  SpendingAnalyticsView.swift
//  TestingLisaApp1
//
//  Created by Jeremy Lumban Toruan on 14/04/25.
//

import SwiftUI
import Charts

struct SpendingAnalyticsView: View {
    
    @ObservedObject var viewModel: ExpenseViewModel
    @State private var selectedTimeframe: Timeframe = .monthly
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Timeframe selector
                Picker("Timeframe", selection: $selectedTimeframe) {
                    ForEach(Timeframe.allCases, id: \.self) { timeframe in
                        Text(timeframe.rawValue).tag(timeframe)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Budget summary at the top
                budgetSummaryView
                
                // Category breakdown chart
                categoryChartView
                
                // Category breakdown list
                categoryBreakdownList
                
                // Top expenses
                topExpensesList
            }
            .padding(.vertical)
        }
        .navigationTitle("Spending Analytics")
    }
    
    private var budgetSummaryView: some View {
        VStack(spacing: 8) {
            Text("Monthly Budget")
                .font(.headline)
                .foregroundColor(.secondary)
            
            if let budget = viewModel.budget {
                Text("Rp\(Int(budget.amount))")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.blue)
                
                let spent = getTotalSpentAmount()
                let remaining = budget.amount - spent
                
                HStack(spacing: 16) {
                    VStack {
                        Text("Spent")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("Rp\(Int(spent))")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                    
                    Divider()
                        .frame(height: 30)
                    
                    VStack {
                        Text("Remaining")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("Rp\(Int(remaining))")
                            .font(.headline)
                            .foregroundColor(remaining >= 0 ? .green : .red)
                    }
                }
                .padding(.top, 4)
            } else {
                Text("No budget set")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private var categoryChartView: some View {
        let categoryData = getCategoryData()
        
        return VStack(alignment: .leading, spacing: 12) {
            Text("Category Spending")
                .font(.headline)
                .padding(.horizontal)
            
            Chart {
                ForEach(categoryData, id: \.category) { item in
                    BarMark(
                        x: .value("Amount", item.amount),
                        y: .value("Category", item.category.rawValue)
                    )
                    .foregroundStyle(categoryColor(for: item.category))
                    .annotation(position: .trailing) {
                        Text("Rp\(Int(item.amount))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(height: CGFloat(categoryData.count * 50))
            .padding()
            .chartYAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        if let category = value.as(String.self),
                           let foundCategory = ExpenseCategory.allCases.first(where: { $0.rawValue == category }) {
                            HStack {
                                Image(systemName: foundCategory.icon)
                                    .foregroundColor(categoryColor(for: foundCategory))
                                Text(category)
                                    .font(.callout)
                            }
                        }
                    }
                }
            }
        }
        .padding(.vertical)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private var categoryBreakdownList: some View {
        // Implementation for a list showing spending by category
        let categoryData = getCategoryData()
        return VStack(alignment: .leading, spacing: 12) {
            Text("Expenses Breakdown")
                .font(.headline)
                .padding(.bottom, 4)
                .padding(.horizontal)
            
            ForEach(categoryData, id: \.category) { item in
                HStack {
                    Image(systemName: item.category.icon)
                        .foregroundColor(categoryColor(for: item.category))
                        .frame(width: 24)
                    
                    Text(item.category.rawValue)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Rp\(Int(item.amount))")
                            .fontWeight(.medium)
                        
                        Text("\(Int(item.percentage))%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private var topExpensesList: some View {
        // Implementation for listing top expenses
        let topExpenses = getTopExpenses(limit: 5)
        return VStack(alignment: .leading, spacing: 12) {
            Text("Top Expenses")
                .font(.headline)
                .padding(.bottom, 4)
                .padding(.horizontal)
            
            if topExpenses.isEmpty {
                Text("No expenses in selected timeframe")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ForEach(topExpenses) { expense in
                    HStack {
                        Image(systemName: expense.category.icon)
                            .foregroundColor(categoryColor(for: expense.category))
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(expense.notes ?? expense.category.rawValue)
                                .fontWeight(.medium)
                            
                            Text(expense.date, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text("-Rp\(Int(expense.amount))")
                            .foregroundColor(.red)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                }
            }
        }
        .padding(.vertical)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    // Helper methods
    private func getCategoryData() -> [(category: ExpenseCategory, amount: Double, percentage: Double)] {
        // Implementation to calculate category data
        var result: [(category: ExpenseCategory, amount: Double, percentage: Double)] = []
        let filteredExpenses = getFilteredExpenses()
        let total = filteredExpenses.reduce(0) { $0 + $1.amount }
        
        for category in ExpenseCategory.allCases {
            let categoryTotal = filteredExpenses
                .filter { $0.category == category }
                .reduce(0) { $0 + $1.amount }
            
            if categoryTotal > 0 {
                let percentage = total > 0 ? (categoryTotal / total) * 100 : 0
                result.append((category, categoryTotal, percentage))
            }
        }
        
        return result.sorted { $0.amount > $1.amount }
    }
    
    private func getTotalSpentAmount() -> Double {
        return getFilteredExpenses().reduce(0) { $0 + $1.amount }
    }
    
    private func getTopExpenses(limit: Int) -> [Expense] {
        return getFilteredExpenses()
            .sorted { $0.amount > $1.amount }
            .prefix(limit)
            .map { $0 }
    }
    
    private func getFilteredExpenses() -> [Expense] {
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedTimeframe {
        case .daily:
            return viewModel.expenses.filter { calendar.isDateInToday($0.date) }
        case .weekly:
            let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
            return viewModel.expenses.filter { $0.date >= weekStart }
        case .monthly:
            let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
            return viewModel.expenses.filter { $0.date >= monthStart }
        }
    }
    
    private func categoryColor(for category: ExpenseCategory) -> Color {
        switch category {
        case .food: return .blue
        case .transportation: return .green
        case .clothes: return .orange
        }
    }
}

#Preview {
    NavigationView {
        SpendingAnalyticsView(viewModel: {
            let vm = ExpenseViewModel()
            // Add some sample data
            vm.setBudget(amount: 5000000)
            vm.addExpense(amount: 500000, category: .food, notes: "Dinner")
            vm.addExpense(amount: 300000, category: .transportation, notes: "Gas")
            vm.addExpense(amount: 1200000, category: .clothes, notes: "Shoes")
            return vm
        }())
    }
}
