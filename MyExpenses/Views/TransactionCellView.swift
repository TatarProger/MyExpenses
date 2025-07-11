//
//  TransactionCell.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 04.07.2025.
//

import SwiftUI

struct TransactionCellView: View {
    let transaction: Transaction

    var body: some View {
        HStack(spacing: 12) {
            Color.clear
                .frame(width: transaction.category.income == .outcome ? 24 : 0)

            VStack(alignment: .leading) {
                Text(transaction.category.name)
                    .font(.system(size: 17))
                    .foregroundColor(.primary)

                if transaction.category.income == .outcome,
                   let comment = transaction.comment,
                   !comment.isEmpty {
                    Text(comment)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            HStack(spacing: 4) {
                Text("\(transaction.amount) ₽")
                    .font(.system(size: 16))
            }
        }
        .overlay(alignment: .leading) {
            if transaction.category.income == .outcome {
                Text("\(transaction.category.emoji)")
                    .font(.system(size: 14.5))
                    .frame(width: 24, height: 24)
                    .background(Color.mintAccent)
                    .cornerRadius(12)
            }
        }
    }
}
