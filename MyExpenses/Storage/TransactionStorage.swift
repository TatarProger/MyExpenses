//
//  TransactionStorage.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 19.07.2025.
//

import SwiftData
import Foundation

@MainActor
final class TransactionStorage {
    private let modelContainer: ModelContainer
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    // Save or update transaction
    func save(transaction: Transaction) throws {
        let context = modelContainer.mainContext
        
        if let existing = try fetchEntity(by: transaction.id) {
            updateEntity(existing, with: transaction)
        } else {
            let newEntity = TransactionEntity(transaction: transaction)
            context.insert(newEntity)
        }
        
        try context.save()
    }

    // Fetch all transactions
    func fetchAll() throws -> [TransactionEntity] {
        let context = modelContainer.mainContext
        let fetchDescriptor = FetchDescriptor<TransactionEntity>()
        return try context.fetch(fetchDescriptor)
    }

    // Fetch by ID
    func fetchEntity(by id: Int) throws -> TransactionEntity? {
        let context = modelContainer.mainContext
        let predicate = #Predicate<TransactionEntity> { $0.id == id }
        let fetchDescriptor = FetchDescriptor<TransactionEntity>(predicate: predicate)
        return try context.fetch(fetchDescriptor).first
    }

    // Delete by ID
    func delete(by id: Int) throws {
        if let entity = try fetchEntity(by: id) {
            let context = modelContainer.mainContext
            context.delete(entity)
            try context.save()
        }
    }

    // Update existing entity
    private func updateEntity(_ entity: TransactionEntity, with transaction: Transaction) {
        entity.accountId = transaction.account.id
        entity.accountName = transaction.account.name
        entity.accountBalance = NSDecimalNumber(decimal: transaction.account.balance).doubleValue
        entity.accountCurrency = transaction.account.currency

        entity.categoryId = transaction.category.id
        entity.categoryName = transaction.category.name
        entity.categoryEmoji = String(transaction.category.emoji)
        entity.isIncome = transaction.category.income == .income

        entity.amount = NSDecimalNumber(decimal: transaction.amount).doubleValue
        entity.transactionDate = transaction.transactionDate
        entity.comment = transaction.comment
        entity.createdAt = transaction.createdAt
        entity.updatedAt = transaction.updatedAt
    }

}


extension TransactionStorage {
    func save(transactions: [Transaction]) throws {
        for transaction in transactions {
            try save(transaction: transaction)
        }
    }
}
