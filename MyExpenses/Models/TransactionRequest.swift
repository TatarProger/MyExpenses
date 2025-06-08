//
//  TransactionRequest.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 08.06.2025.
//

import Foundation

struct TransactionRequest: Codable {
    let accountId: Int
    let categoryId: Int
    let amount: String
    let transactionDate: String
}
