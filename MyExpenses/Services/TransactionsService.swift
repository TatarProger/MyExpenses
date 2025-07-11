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
    
    private var categoriesService: CategoriesService

    init(categoriesService: CategoriesService) {
        self.categoriesService = categoriesService
    }
    
    private var transactions = [
        Transaction(
            id: 1,
            account: AccountBrief(id: 1, name: "Основной счет", balance: 1000, currency: "RUB"),
            category: Category(id: 1, name: "Питомцы", emoji: "🐶", income: .outcome),
            amount: 1000,
            transactionDate: ISO8601DateFormatter().date(from: "2025-06-18T00:01:00.000Z"),
            comment: "Корм для собаки",
            createdAt: Date(),
            updatedAt: Date()
        ),
        Transaction(id: 3, account: AccountBrief(id: 1, name: "Основной счет", balance: 1000, currency: "RUB"), category: Category(id: 3, name: "Одежда", emoji: "👗", income: .outcome), amount: 3500, transactionDate: Date(), comment: "Платье", createdAt: Date(), updatedAt: Date()),
        Transaction(id: 4, account: AccountBrief(id: 1, name: "Основной счет", balance: 1000, currency: "RUB"), category: Category(id: 4, name: "Фриланс", emoji: "🧑‍💻", income: .income), amount: 12000, transactionDate: Date(), comment: "Проект сайта", createdAt: Date(), updatedAt: Date()),
        Transaction(id: 5, account: AccountBrief(id: 1, name: "Основной счет", balance: 1000, currency: "RUB"), category: Category(id: 5, name: "Продукты", emoji: "🛒", income: .outcome), amount: 2500, transactionDate: Date(), comment: "Магазин у дома", createdAt: Date(), updatedAt: Date()),
        Transaction(id: 6, account: AccountBrief(id: 1, name: "Основной счет", balance: 1000, currency: "RUB"), category: Category(id: 6, name: "Бонус", emoji: "🎉", income: .income), amount: 8000, transactionDate: Date(), comment: "Годовой бонус", createdAt: Date(), updatedAt: Date()),
        Transaction(id: 7, account: AccountBrief(id: 1, name: "Основной счет", balance: 1000, currency: "RUB"), category: Category(id: 7, name: "Транспорт", emoji: "🚗", income: .outcome), amount: 1200, transactionDate: Date(), comment: "Заправка", createdAt: Date(), updatedAt: Date()),
        Transaction(id: 8, account: AccountBrief(id: 1, name: "Основной счет", balance: 1000, currency: "RUB"), category: Category(id: 8, name: "Проценты", emoji: "🏦", income: .income), amount: 300, transactionDate: Date(), comment: "Счет в банке", createdAt: Date(), updatedAt: Date()),
        Transaction(id: 9, account: AccountBrief(id: 1, name: "Основной счет", balance: 1000, currency: "RUB"), category: Category(id: 9, name: "Кафе", emoji: "☕️", income: .outcome), amount: 700, transactionDate: Date(), comment: "Кофе и десерт", createdAt: Date(), updatedAt: Date()),
        Transaction(id: 10, account: AccountBrief(id: 1, name: "Основной счет", balance: 1000, currency: "RUB"), category: Category(id: 10, name: "Доп. работа", emoji: "💼", income: .income), amount: 15000, transactionDate: Date(), comment: "Перевод за подработку", createdAt: Date(), updatedAt: Date())
    ]

    
    func fetchTransactionsForPeriod(_ id: Int, _ startDate: Date, _ endDate: Date) async throws -> [Transaction] {
        
        print("start->",startDate)
        print("end->",endDate)
        
      
        
        let array = transactions.filter {
            if let date = $0.transactionDate {
                print(date)
                
                print(date > startDate)
                print(date < endDate)
                
                return date >= startDate && date <= endDate
            } else {
                print("Отсутвие даты")
                return false
            }
        }
        
        return array
    }
    
    func makeTransaction(
        id: Int,
        accountId: Int,
        categoryId: Int,
        amount: Decimal,
        transactionDate: Date?,
        comment: String?
    ) async throws -> TransactionPut {
        
        let account = AccountBrief(id: accountId, name: "Основной счет", balance: 0, currency: "RUB")
        
        // Получаем категории из CategoriesService
        let allCategories = try await categoriesService.fetchCategories()
        guard let category = allCategories.first(where: { $0.id == categoryId }) else {
            throw NSError(domain: "CategoryNotFound", code: 404, userInfo: nil)
        }
        
        let transaction = Transaction(
            id: id,
            account: account,
            category: category,
            amount: amount,
            transactionDate: transactionDate ?? Date(),
            comment: comment,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        transactions.append(transaction)
        
        return TransactionPut(
            id: id,
            accountId: accountId,
            categoryId: categoryId,
            amount: amount,
            transactionDate: transactionDate,
            comment: comment
        )
    }
    
    func updateTransaction(
        _ id: Int,
        _ accountId: Int,
        _ categoryId: Int,
        amount: Decimal,
        _ transactionDate: Date,
        _ comment: String
    ) async throws -> Transaction {

        guard let index = transactions.firstIndex(where: { $0.id == id }) else {
            throw NSError(domain: "TransactionNotFound", code: 404, userInfo: nil)
        }

        let allCategories = try await categoriesService.fetchCategories()
        guard let category = allCategories.first(where: { $0.id == categoryId }) else {
            throw NSError(domain: "CategoryNotFound", code: 404, userInfo: nil)
        }

        let account = AccountBrief(id: accountId, name: "Основной счет", balance: 0, currency: "RUB")

        let updated = Transaction(
            id: id,
            account: account,
            category: category,
            amount: amount,
            transactionDate: transactionDate,
            comment: comment,
            createdAt: transactions[index].createdAt,
            updatedAt: Date()
        )

        transactions[index] = updated
        return updated
    }


    
    

//    func makeTransaction(id: Int, accountId: Int, categoryId: Int, amount: Decimal, transactionDate: Date?, comment: String?) async throws -> TransactionPut {
//        TransactionPut(id: id, accountId: accountId, categoryId: categoryId, amount: amount, transactionDate: transactionDate, comment: comment)
//    }
    
//    func updateTransaction(_ id: Int, _ accountId: Int, _ categoryId: Int, amount: Decimal, _ transactionDate: Date, _ comment: String) async throws -> Transaction {
//        let transaction = transactions.first(where: ) {$0.id == id}
//        let account = AccountBrief(id: accountId, name: transaction?.account.name ?? "", balance: transaction?.account.balance ?? Decimal(), currency: transaction?.account.currency ?? "")
//        
//        let category = Category(id: categoryId, name: transaction?.category.name ?? "", emoji: transaction?.category.emoji ?? " ", income: transaction?.category.income ?? Direction.income)
//        
//        return Transaction(id: transaction?.id ?? 0, account: account, category: category, amount: transaction?.amount ?? Decimal(1000), transactionDate: transaction?.transactionDate, comment: transaction?.comment, createdAt: Date.now, updatedAt: Date.now)
//    }
    
    func removeTransaction(id: Int) async throws {
        transactions.removeAll(where: ){$0.id == id}
    }
    
}
