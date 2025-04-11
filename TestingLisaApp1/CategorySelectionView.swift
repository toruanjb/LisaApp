//
//  CategorySelectionView.swift
//  TestingLisaApp1
//
//  Created by Jeremy Lumban Toruan on 31/03/25.
//

import SwiftUI

struct CategorySelectionView: View {
    @Binding var selectedCategory: ExpenseCategory?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Select Category")
                .font(.title)
                .padding()
            
            VStack(spacing: 15) {
                ForEach(ExpenseCategory.allCases, id: \.self) { category in
                    Button(action: {
                        selectedCategory = category
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: category.icon)
                            Text(category.rawValue)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
    }
}
