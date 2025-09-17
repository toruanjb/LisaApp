//
//  MainTabView.swift
//  TestingLisaApp1
//
//  Created by Jeremy Lumban Toruan on 14/04/25.
//
import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = ExpenseViewModel()
    
    var body: some View {
        TabView {
            // Home Screen
            HomeView()
                .environmentObject(viewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            // Budget Overview Screen (Placeholder)
            SpendingAnalyticsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Analytics")
                }
        }
    }
}

//// New Budget Overview View
//struct BudgetOverviewView: View {
//    @ObservedObject var viewModel: ExpenseViewModel
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                // Budget Summary
//                if let budget = viewModel.budget {
//                    VStack {
//                        Text("Monthly Budget")
//                            .font(.title2)
//                            .padding()
//                        
//                        Text("Rp\(Int(budget.amount))")
//                            .font(.largeTitle)
//                            .foregroundColor(.blue)
//                        
//                        // Expenses by Category
//                        Text("Expenses Breakdown")
//                            .font(.headline)
//                            .padding()
//                        
//                        ForEach(ExpenseCategory.allCases, id: \.self) { category in
//                            let categoryTotal = viewModel.expenses
//                                .filter { $0.category == category }
//                                .reduce(0) { $0 + $1.amount }
//                            
//                            HStack {
//                                Image(systemName: category.icon)
//                                    .foregroundColor(.blue)
//                                Text(category.rawValue)
//                                Spacer()
//                                Text("-Rp\(Int(categoryTotal))")
//                                    .foregroundColor(.red)
//                            }
//                            .padding()
//                            .background(Color(.systemGray6))
//                            .cornerRadius(10)
//                            .padding(.horizontal)
//                        }
//                    }
//                } else {
//                    Text("Please Set Your Budget! $$$")
//                        .font(.title)
//                        .foregroundColor(.gray)
//                }
//            }
//            .navigationTitle("Budget Overview")
//        }
//    }
//}

#Preview {
    MainTabView()
        .environmentObject(ExpenseViewModel())
}
