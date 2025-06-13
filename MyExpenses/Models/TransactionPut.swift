//
//  TransactionPut.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 11.06.2025.
//

import Foundation

struct TransactionPut: Decodable {
    let id: Int
    let accountId: Int
    let categoryId: Int
    let amount: Decimal
    let transactionDate: Date?
    let comment: String?
}
