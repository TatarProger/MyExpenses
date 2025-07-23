//
//  BankAccountEntity.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 23.07.2025.
//

import Foundation
import SwiftData

@Model
final class BankAccountEntity {
    var id: Int
    var userId: Int
    var name: String
    var balance: Decimal
    var currency: String
    var createdAt: Date
    var updatedAt: Date

    init(
        id: Int,
        userId: Int,
        name: String,
        balance: Decimal,
        currency: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.userId = userId
        self.name = name
        self.balance = balance
        self.currency = currency
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
