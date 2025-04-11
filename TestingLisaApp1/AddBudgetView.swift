//
//  AddBudgetView.swift
//  TestingLisaApp1
//
//  Created by Jeremy Lumban Toruan on 26/03/25.
//

import SwiftUI

struct AddBudgetView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ExpenseViewModel
    @State private var budgetAmount: String = ""

    var body: some View {
        VStack {
            Text("Set Your Budget")
                .font(.title)
                .bold()
                .padding()

            TextField("Enter budget amount", text: $budgetAmount)
                .keyboardType(.numberPad)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

            Button(action: {
                if let amount = Double(budgetAmount) {
                    viewModel.setBudget(amount: amount)
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Save Budget")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .padding()
    }
}
