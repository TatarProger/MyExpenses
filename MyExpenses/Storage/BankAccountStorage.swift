//
//  BankAccountStorage.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 23.07.2025.
//

import Foundation
import SwiftData

final class BankAccountStorage {
    private let modelContainer: ModelContainer

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    func save(account: BankAccount) async throws {
        let context = await modelContainer.mainContext

        let entity = BankAccountEntity(
            id: account.id,
            userId: account.userId,
            name: account.name,
            balance: account.balance,
            currency: account.currency,
            createdAt: account.createdAt,
            updatedAt: account.updatedAt
        )

        context.insert(entity)
        try context.save()
    }

    func fetchAll() async throws -> [BankAccount] {
        let context = await modelContainer.mainContext

        let descriptor = FetchDescriptor<BankAccountEntity>()
        let entities = try context.fetch(descriptor)

        return entities.map {
            BankAccount(
                id: $0.id,
                userId: $0.userId,
                name: $0.name,
                balance: $0.balance,
                currency: $0.currency,
                createdAt: $0.createdAt,
                updatedAt: $0.updatedAt
            )
        }
    }

    func deleteAll() async throws {
        let context = await modelContainer.mainContext
        let fetchDescriptor = FetchDescriptor<BankAccountEntity>()
        let all = try context.fetch(fetchDescriptor)
        all.forEach { context.delete($0) }
        try context.save()
    }
}
