//
//  TransactionEntity.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 19.07.2025.
//

import SwiftData
import Foundation



@Model
class TransactionEntity {
    @Attribute(.unique) var id: Int
    var accountId: Int
    var accountName: String
    var accountBalance: Double
    var accountCurrency: String

    var categoryId: Int
    var categoryName: String
    var categoryEmoji: String
    var isIncome: Bool

    var amount: Double
    var transactionDate: Date?
    var comment: String?
    var createdAt: Date
    var updatedAt: Date

    init(transaction: Transaction) {
        self.id = transaction.id
        self.accountId = transaction.account.id
        self.accountName = transaction.account.name
        self.accountBalance = NSDecimalNumber(decimal: transaction.account.balance).doubleValue
        self.accountCurrency = transaction.account.currency

        self.categoryId = transaction.category.id
        self.categoryName = transaction.category.name
        self.categoryEmoji = String(transaction.category.emoji)
        self.isIncome = transaction.category.income == .income

        self.amount = NSDecimalNumber(decimal: transaction.amount).doubleValue
        self.transactionDate = transaction.transactionDate
        self.comment = transaction.comment
        self.createdAt = transaction.createdAt
        self.updatedAt = transaction.updatedAt
    }
}

