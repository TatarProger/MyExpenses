//
//  TransactionsService.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 08.06.2025.
//

import Foundation
protocol TransactionsServiceProtocol {
    func fetchTransactionsForPeriod(_ id: Int, _ startDate: Date, _ endDate: Date) async throws -> [Transaction]
    func makeTransaction(id: Int, accountId: Int, categoryId: Int, amount: Decimal, transactionDate: Date?, comment: String?) async throws -> TransactionPut
    func updateTransaction(_ id: Int, _ accountId: Int, _ categoryId: Int, amount: Decimal, _ transactionDate: Date, _ comment: String)  async throws -> Transaction
    func removeTransaction(id: Int) async throws
}

class TransactionsService: TransactionsServiceProtocol {
    
    private var transactions = [Transaction(id: 1, account: AccountBrief(id: 1, name: "Основной счет", balance: Decimal(1000.00), currency: "RUB"), category: Category(id: 1, name: "Питомцы", emoji: "🦁", income: .income), amount: Decimal(1000.00), transactionDate: ISO8601DateFormatter().date(from: "2004-06-11T00:00:00.000Z"), comment: "", createdAt: ISO8601DateFormatter().date(from: "2025-06-10T15:39:13.576Z") ?? Date(), updatedAt: ISO8601DateFormatter().date(from: "2025-06-10T15:39:13.576Z") ?? Date())]
    
    func fetchTransactionsForPeriod(_ id: Int, _ startDate: Date, _ endDate: Date) async throws -> [Transaction] {
        transactions.filter{$0.createdAt >= startDate && $0.createdAt <= endDate}
    }

    func makeTransaction(id: Int, accountId: Int, categoryId: Int, amount: Decimal, transactionDate: Date?, comment: String?) async throws -> TransactionPut {
        TransactionPut(id: id, accountId: accountId, categoryId: categoryId, amount: amount, transactionDate: transactionDate, comment: comment)
    }
    
    func updateTransaction(_ id: Int, _ accountId: Int, _ categoryId: Int, amount: Decimal, _ transactionDate: Date, _ comment: String) async throws -> Transaction {
        let transaction = transactions.first(where: ) {$0.id == id}
        let account = AccountBrief(id: accountId, name: transaction?.account.name ?? "", balance: transaction?.account.balance ?? Decimal(), currency: transaction?.account.currency ?? "")
        
        let category = Category(id: categoryId, name: transaction?.category.name ?? "", emoji: transaction?.category.emoji ?? " ", income: transaction?.category.income ?? Direction.income)
        
        return Transaction(id: transaction?.id ?? 0, account: account, category: category, amount: transaction?.amount ?? Decimal(1000), transactionDate: transaction?.transactionDate, comment: transaction?.comment, createdAt: Date.now, updatedAt: Date.now)
    }
    
    func removeTransaction(id: Int) async throws {
        transactions.removeAll(where: ){$0.id == id}
    }
    
}
