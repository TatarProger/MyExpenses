//
//  TranactionStorage.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 23.07.2025.
//

import SwiftData
import Foundation

@MainActor
final class TransactionStorage {
    private let modelContainer: ModelContainer

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    // MARK: - Create

//    func create(transaction: Transaction) throws {
//        let context = modelContainer.mainContext
//
//
//        if try fetchEntity(by: transaction.id) != nil {
//            throw NSError(domain: "TransactionStorage", code: 1, userInfo: [NSLocalizedDescriptionKey: "Transaction with this ID already exists."])
//        }
//
//        let newEntity = TransactionEntity(transaction: transaction)
//        context.insert(newEntity)
//        try context.save()
//    }
    
    func create(transaction: Transaction, isSynced: Bool = true) throws {
        let context = modelContainer.mainContext


        if try fetchEntity(by: transaction.id) != nil {
            throw NSError(domain: "TransactionStorage", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Transaction with this ID already exists."
            ])
        }

        let newEntity = TransactionEntity(transaction: transaction)
        newEntity.isSynced = isSynced
        context.insert(newEntity)
        try context.save()
    }

    
    func fetchByAccountAndPeriod(accountId: Int, startDate: Date, endDate: Date) throws -> [TransactionEntity] {
        let predicate = #Predicate<TransactionEntity> {
            $0.accountId == accountId
        }

        let context = modelContainer.mainContext
        let fetchDescriptor = FetchDescriptor<TransactionEntity>(predicate: predicate)
        let results = try context.fetch(fetchDescriptor)

        let filtered = results.filter {
            guard let date = $0.transactionDate else { return false }
            return date >= startDate && date <= endDate
        }

        return filtered
    }



    // MARK: - Read

    func fetchAll() throws -> [TransactionEntity] {
        let context = modelContainer.mainContext
        let fetchDescriptor = FetchDescriptor<TransactionEntity>()
        return try context.fetch(fetchDescriptor)
    }

    func fetchEntity(by id: Int) throws -> TransactionEntity? {
        let context = modelContainer.mainContext
        let predicate = #Predicate<TransactionEntity> { $0.id == id }
        let fetchDescriptor = FetchDescriptor<TransactionEntity>(predicate: predicate)
        return try context.fetch(fetchDescriptor).first
    }

    // MARK: - Update

    func update(id: Int, with transaction: Transaction) throws {
        guard let existing = try fetchEntity(by: id) else {
            throw NSError(domain: "TransactionStorage", code: 2, userInfo: [NSLocalizedDescriptionKey: "Transaction not found."])
        }

        updateEntity(existing, with: transaction)
        try modelContainer.mainContext.save()
    }

    // MARK: - Delete

    func delete(by id: Int) throws {
        guard let entity = try fetchEntity(by: id) else {
            throw NSError(domain: "TransactionStorage", code: 3, userInfo: [NSLocalizedDescriptionKey: "Transaction not found."])
        }

        let context = modelContainer.mainContext
        context.delete(entity)
        try context.save()
    }

    // MARK: - Helper

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
    
    func fetchPendingSync() throws -> [Transaction] {
        let context = modelContainer.mainContext
        let predicate = #Predicate<TransactionEntity> { $0.isSynced == false }
        let entities = try context.fetch(FetchDescriptor(predicate: predicate))
        return entities.map { Transaction(from: $0) }
    }

    func markAsSynced(id: Int) throws {
        guard let entity = try fetchEntity(by: id) else { return }
        entity.isSynced = true
        try modelContainer.mainContext.save()
    }

}

extension TransactionStorage {
    func save(transactions: [Transaction]) throws {
        for transaction in transactions {
            do {
                try create(transaction: transaction)
            } catch {
                try update(id: transaction.id, with: transaction)
            }
        }
    }
}
