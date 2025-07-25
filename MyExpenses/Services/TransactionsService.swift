//
//  TransactionsService.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 08.06.2025.
//

import Foundation
import SwiftData


class TransactionsService {
    
    @MainActor
    func BankAccountsServiceGet() -> BankAccountsService {
        return AppServices.shared.bankAccountsService
    }
    
    @MainActor
    func categoriesServiceGet() -> CategoriesService {
        return AppServices.shared.categoriesService
    }

    private let networkClient: NetworkClient
    private let storage: TransactionStorage

    init(networkClient: NetworkClient, storage: TransactionStorage) {
        self.networkClient = networkClient
        self.storage = storage
    }

    // MARK: - Fetch Transactions (from API and save locally)

    func fetchTransactionsForPeriod(_ id: Int, _ startDate: Date, _ endDate: Date) async throws -> [Transaction] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)

        let endpoint = "/api/v1/transactions/account/\(id)/period?startDate=\(startDateString)&endDate=\(endDateString)"

        do {
            let transactions: [Transaction] = try await networkClient.request(
                endpoint: endpoint,
                method: "GET",
                requestBody: EmptyRequest()
            )
            
          
            try await storage.save(transactions: transactions)

            return transactions
        } catch {
            print("⚠️ Ошибка при загрузке транзакций: \(error)")
            print(" Используем данные из хранилища")

            let all = try await storage.fetchAll()

            let transactions = try await storage.fetchByAccountAndPeriod(accountId: id, startDate: startDate, endDate: endDate)
            
            let entities = try await storage.fetchByAccountAndPeriod(accountId: id, startDate: startDate, endDate: endDate)
            let transactions1 = entities.map { Transaction(from: $0) }
            return transactions1


        }
    }


    // MARK: - Create Transaction

    func makeTransaction(
        id: Int,
        accountId: Int,
        categoryId: Int,
        amount: Decimal,
        transactionDate: Date?,
        comment: String?
    ) async throws -> TransactionPut {
        
        struct Request: Encodable {
            let accountId: Int
            let categoryId: Int
            let amount: Decimal
            let transactionDate: String?
            let comment: String?
        }


        func newUTC(from date: Date) -> Date {
            return date.addingTimeInterval(2 * 60 * 60)
        }

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        let shiftedDate = transactionDate.map { newUTC(from: $0) }
        let dateString = shiftedDate.map { formatter.string(from: $0) }


        let requestBody = Request(
            accountId: accountId,
            categoryId: categoryId,
            amount: amount,
            transactionDate: dateString,
            comment: comment
        )

        let result: TransactionPut = try await networkClient.request(
            endpoint: "/api/v1/transactions",
            method: "POST",
            requestBody: requestBody
        )

        return result
    }




    // MARK: - Update Transaction

    func updateTransaction(_ id: Int, _ accountId: Int, _ categoryId: Int, amount: Decimal, _ transactionDate: Date, _ comment: String) async throws -> Transaction {
        struct Request: Encodable {
            let accountId: Int
            let categoryId: Int
            let amount: Decimal
            let transactionDate: String
            let comment: String
        }

        let formatter = ISO8601DateFormatter()
        let requestBody = Request(
            accountId: accountId,
            categoryId: categoryId,
            amount: amount,
            transactionDate: formatter.string(from: transactionDate),
            comment: comment
        )

        let updatedTransaction: Transaction = try await networkClient.request(
            endpoint: "/api/v1/transactions/\(id)",
            method: "PUT",
            requestBody: requestBody
        )


        try await storage.update(id: id, with: updatedTransaction)

        return updatedTransaction
    }

    // MARK: - Remove Transaction

    func removeTransaction(id: Int) async throws {
        let _: EmptyResponse = try await networkClient.request<EmptyRequest, EmptyResponse>(
            endpoint: "/api/v1/transactions/\(id)",
            method: "DELETE",
            requestBody: EmptyRequest()
        )

        try await storage.delete(by: id)
    }
    
    func syncPendingTransactions() async {
        do {
            let pending = try await storage.fetchPendingSync()

            for transaction in pending {
                do {
                    _ = try await makeTransaction(
                        id: transaction.id,
                        accountId: transaction.account.id,
                        categoryId: transaction.category.id,
                        amount: transaction.amount,
                        transactionDate: transaction.transactionDate,
                        comment: transaction.comment
                    )

                    try await storage.markAsSynced(id: transaction.id)

                } catch {
                    print(" Failed to sync transaction \(transaction.id): \(error)")
                    continue
                }
            }

        } catch {
            print(" Failed to load pending transactions: \(error)")
        }
    }

}
