//
//  CategoryCellView.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 04.07.2025.
//

import SwiftUI

struct CategoryCellView: View {
    let transaction: Transaction

    var body: some View {
        HStack(spacing: 12) {
            Color.clear
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.category.name)
                    .font(.system(size: 17))
                    .foregroundColor(.primary)
            }

            Spacer()

            HStack(spacing: 4) {
                Text("\(transaction.amount) ₽")
                    .font(.system(size: 16))
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .overlay(alignment: .leading) {
            Text("\(transaction.category.emoji)")
                .font(.system(size: 14.5))
                .frame(width: 24, height: 24)
                .background(Color.mintAccent)
                .cornerRadius(12)
        }
    }
}
