//
//  TransactionRepository.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 19.07.2025.
//
import Foundation

//@MainActor
//final class TransactionRepository {
//    private let networkService: TransactionsServiceProtocol
//    private let storage: TransactionStorage
//    private let backupStorage: TransactionsBackupCache
//
//    init(networkService: TransactionsServiceProtocol, storage: TransactionStorage, backupStorage: TransactionsBackupCache) {
//        self.networkService = networkService
//        self.storage = storage
//        self.backupStorage = backupStorage
//    }
//
//    func syncAndLoadTransactions(accountId: Int, startDate: Date, endDate: Date) async throws -> [TransactionEntity] {
//        try await syncBackupToServer()
//
//        if isNetworkAvailable() {
//            do {
//                let transactions = try await networkService.fetchTransactionsForPeriod(accountId, startDate, endDate)
//                try storage.save(transactions: transactions)
//
//                let entities = try storage.fetchAll()
//                return entities
//            } catch {
//                print("⚠️ Ошибка загрузки с сервера: \(error). Используем локальные данные.")
//                return try mergeLocalWithBackup(accountId: accountId, startDate: startDate, endDate: endDate)
//            }
//        } else {
//            print("❌ Нет интернета. Используем локальные данные.")
//            return try mergeLocalWithBackup(accountId: accountId, startDate: startDate, endDate: endDate)
//        }
//    }
//
//    private func mergeLocalWithBackup(accountId: Int, startDate: Date, endDate: Date) throws -> [TransactionEntity] {
//        let localEntities = try storage.fetchAll()
//        let backupItems = try backupStorage.allItems()
//
//        let backupEntities = backupItems
//            .map { TransactionEntity(transaction: $0.transaction) }
//            .filter { $0.accountId == accountId && ($0.transactionDate ?? Date()) >= startDate && ($0.transactionDate ?? Date()) <= endDate }
//
//        let merged = (localEntities + backupEntities)
//            .uniqued(by: { $0.id })
//
//        return merged
//    }
//
//    private func isNetworkAvailable() -> Bool {
//        // Подключите сюда реальную проверку через NWPathMonitor или аналог
//        return true
//    }
//
//    private func syncBackupToServer() async throws {
//        let backupItems = try backupStorage.allItems()
//
//        for item in backupItems {
//            do {
//                switch item.action {
//                case .create:
//                    _ = try await networkService.makeTransaction(
//                        id: item.transaction.id,
//                        accountId: item.transaction.account.id,
//                        categoryId: item.transaction.category.id,
//                        amount: item.transaction.amount,
//                        transactionDate: item.transaction.transactionDate,
//                        comment: item.transaction.comment
//                    )
//                case .update:
//                    _ = try await networkService.updateTransaction(
//                        item.transaction.id,
//                        item.transaction.account.id,
//                        item.transaction.category.id,
//                        amount: item.transaction.amount,
//                        item.transaction.transactionDate ?? Date(),
//                        item.transaction.comment ?? ""
//                    )
//                case .delete:
//                    try await networkService.removeTransaction(id: item.transaction.id)
//                }
//
//                try backupStorage.remove(item)
//            } catch {
//                print("❌ Не удалось синхронизировать бэкап элемент id=\(item.id): \(error)")
//                continue
//            }
//        }
//    }
//}
