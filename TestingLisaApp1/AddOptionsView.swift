////
////  AddOptionsView.swift
////  TestingLisaApp1
////
////  Created by Jeremy Lumban Toruan on 26/03/25.
////
//
//import SwiftUI
//
//struct AddOptionsView: View {
//    @ObservedObject var viewModel: ExpenseViewModel
//    @Environment(\.presentationMode) var presentationMode
//    @State private var showingAddExpense = false
//    @State private var showingAddBudget = false
//    
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 20) {
//                Button(action: {
//                    showingAddExpense = true
//                }) {
//                    HStack {
//                        Image(systemName: "dollarsign.circle")
//                            .foregroundColor(.blue)
//                        Text("Add Expense")
//                            .foregroundColor(.primary)
//                    }
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(Color.blue.opacity(0.1))
//                    .cornerRadius(10)
//                }
//                
//                Button(action: {
//                    showingAddBudget = true
//                }) {
//                    HStack {
//                        Image(systemName: "chart.bar")
//                            .foregroundColor(.blue)
//                        Text("Set Budget")
//                            .foregroundColor(.primary)
//                    }
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(Color.blue.opacity(0.1))
//                    .cornerRadius(10)
//                }
//            }
//            .padding()
//            .navigationTitle("Add")
//            .sheet(isPresented: $showingAddExpense) {
//                AddExpenseView(viewModel: viewModel, initialMode: .expense)
//            }
//            .sheet(isPresented: $showingAddBudget) {
//                AddExpenseView(viewModel: viewModel, initialMode: .budget)
//            }
//        }
//    }
//}
