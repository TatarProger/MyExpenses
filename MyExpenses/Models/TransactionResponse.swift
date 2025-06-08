//
//  TransactionResponse.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 08.06.2025.
//

import Foundation

struct TransactionResponse: Codable {
    let id: Int
    let account: AccountBrief
    let category: Category
    let amount: String
    let transactionDate: String
    let createdAt: String
    let uodatedAt: String
}
