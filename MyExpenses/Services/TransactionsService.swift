//
//  TransactionsService.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 08.06.2025.
//

//import Foundation
//protocol TransactionsServiceProtocol {
//    func fetchTransactionsForPeriod(_ id: Int, _ startDate: Date, _ endDate: Date) async throws -> [Transaction]
//    func makeTransaction(id: Int, accountId: Int, categoryId: Int, amount: Decimal, transactionDate: Date?, comment: String?) async throws -> TransactionPut
//    func updateTransaction(_ id: Int, _ accountId: Int, _ categoryId: Int, amount: Decimal, _ transactionDate: Date, _ comment: String)  async throws -> Transaction
//    func removeTransaction(id: Int) async throws
//}
//
//class TransactionsService: TransactionsServiceProtocol {
//    
//    private var categoriesService: CategoriesService
//
//    init(categoriesService: CategoriesService) {
//        self.categoriesService = categoriesService
//    }
//    
//    private var transactions = [
//        Transaction(
//            id: 1,
//            account: AccountBrief(id: 1, name: "Основной счет", balance: 1000, currency: "RUB"),
//            category: Category(id: 1, name: "Питомцы", emoji: "🐶", income: .outcome),
//            amount: 1000,
//            transactionDate: ISO8601DateFormatter().date(from: "2025-06-18T00:01:00.000Z"),
//            comment: "Корм для собаки",
//            createdAt: Date(),
//            updatedAt: Date()
//        ),
//        Transaction(id: 3, account: AccountBrief(id: 1, name: "Основной счет", balance: 1000, currency: "RUB"), category: Category(id: 3, name: "Одежда", emoji: "👗", income: .outcome), amount: 3500, transactionDate: Date(), comment: "Платье", createdAt: Date(), updatedAt: Date()),
//        Transaction(id: 4, account: AccountBrief(id: 1, name: "Основной счет", balance: 1000, currency: "RUB"), category: Category(id: 4, name: "Фриланс", emoji: "🧑‍💻", income: .income), amount: 12000, transactionDate: Date(), comment: "Проект сайта", createdAt: Date(), updatedAt: Date()),
//        Transaction(id: 5, account: AccountBrief(id: 1, name: "Основной счет", balance: 1000, currency: "RUB"), category: Category(id: 5, name: "Продукты", emoji: "🛒", income: .outcome), amount: 2500, transactionDate: Date(), comment: "Магазин у дома", createdAt: Date(), updatedAt: Date()),
//        Transaction(id: 6, account: AccountBrief(id: 1, name: "Основной счет", balance: 1000, currency: "RUB"), category: Category(id: 6, name: "Бонус", emoji: "🎉", income: .income), amount: 8000, transactionDate: Date(), comment: "Годовой бонус", createdAt: Date(), updatedAt: Date()),
//        Transaction(id: 7, account: AccountBrief(id: 1, name: "Основной счет", balance: 1000, currency: "RUB"), category: Category(id: 7, name: "Транспорт", emoji: "🚗", income: .outcome), amount: 1200, transactionDate: Date(), comment: "Заправка", createdAt: Date(), updatedAt: Date()),
//        Transaction(id: 8, account: AccountBrief(id: 1, name: "Основной счет", balance: 1000, currency: "RUB"), category: Category(id: 8, name: "Проценты", emoji: "🏦", income: .income), amount: 300, transactionDate: Date(), comment: "Счет в банке", createdAt: Date(), updatedAt: Date()),
//        Transaction(id: 9, account: AccountBrief(id: 1, name: "Основной счет", balance: 1000, currency: "RUB"), category: Category(id: 9, name: "Кафе", emoji: "☕️", income: .outcome), amount: 700, transactionDate: Date(), comment: "Кофе и десерт", createdAt: Date(), updatedAt: Date()),
//        Transaction(id: 10, account: AccountBrief(id: 1, name: "Основной счет", balance: 1000, currency: "RUB"), category: Category(id: 10, name: "Доп. работа", emoji: "💼", income: .income), amount: 15000, transactionDate: Date(), comment: "Перевод за подработку", createdAt: Date(), updatedAt: Date())
//    ]
//
//    
//    func fetchTransactionsForPeriod(_ id: Int, _ startDate: Date, _ endDate: Date) async throws -> [Transaction] {
//        
//        print("start->",startDate)
//        print("end->",endDate)
//        
//      
//        
//        let array = transactions.filter {
//            if let date = $0.transactionDate {
//                print(date)
//                
//                print(date > startDate)
//                print(date < endDate)
//                
//                return date >= startDate && date <= endDate
//            } else {
//                print("Отсутвие даты")
//                return false
//            }
//        }
//        
//        return array
//    }
//    
//    func makeTransaction(
//        id: Int,
//        accountId: Int,
//        categoryId: Int,
//        amount: Decimal,
//        transactionDate: Date?,
//        comment: String?
//    ) async throws -> TransactionPut {
//        
//        let account = AccountBrief(id: accountId, name: "Основной счет", balance: 0, currency: "RUB")
//        
//        // Получаем категории из CategoriesService
//        let allCategories = try await categoriesService.fetchCategories()
//        guard let category = allCategories.first(where: { $0.id == categoryId }) else {
//            throw NSError(domain: "CategoryNotFound", code: 404, userInfo: nil)
//        }
//        
//        let transaction = Transaction(
//            id: id,
//            account: account,
//            category: category,
//            amount: amount,
//            transactionDate: transactionDate ?? Date(),
//            comment: comment,
//            createdAt: Date(),
//            updatedAt: Date()
//        )
//        
//        transactions.append(transaction)
//        
//        return TransactionPut(
//            id: id,
//            accountId: accountId,
//            categoryId: categoryId,
//            amount: amount,
//            transactionDate: transactionDate,
//            comment: comment
//        )
//    }
//    
//    func updateTransaction(
//        _ id: Int,
//        _ accountId: Int,
//        _ categoryId: Int,
//        amount: Decimal,
//        _ transactionDate: Date,
//        _ comment: String
//    ) async throws -> Transaction {
//
//        guard let index = transactions.firstIndex(where: { $0.id == id }) else {
//            throw NSError(domain: "TransactionNotFound", code: 404, userInfo: nil)
//        }
//
//        let allCategories = try await categoriesService.fetchCategories()
//        guard let category = allCategories.first(where: { $0.id == categoryId }) else {
//            throw NSError(domain: "CategoryNotFound", code: 404, userInfo: nil)
//        }
//
//        let account = AccountBrief(id: accountId, name: "Основной счет", balance: 0, currency: "RUB")
//
//        let updated = Transaction(
//            id: id,
//            account: account,
//            category: category,
//            amount: amount,
//            transactionDate: transactionDate,
//            comment: comment,
//            createdAt: transactions[index].createdAt,
//            updatedAt: Date()
//        )
//
//        transactions[index] = updated
//        return updated
//    }
//    
//    func removeTransaction(id: Int) async throws {
//        transactions.removeAll(where: ){$0.id == id}
//    }
//    
//}


import Foundation

protocol TransactionsServiceProtocol {
    func fetchTransactionsForPeriod(_ id: Int, _ startDate: Date, _ endDate: Date) async throws -> [Transaction]
    func makeTransaction(id: Int, accountId: Int, categoryId: Int, amount: Decimal, transactionDate: Date?, comment: String?) async throws -> TransactionPut
    func updateTransaction(_ id: Int, _ accountId: Int, _ categoryId: Int, amount: Decimal, _ transactionDate: Date, _ comment: String) async throws -> Transaction
    func removeTransaction(id: Int) async throws
}

class TransactionsService: TransactionsServiceProtocol {
    
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    // MARK: - Fetch Transactions

    func fetchTransactionsForPeriod(_ id: Int, _ startDate: Date, _ endDate: Date) async throws -> [Transaction] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)

        let endpoint = "/api/v1/transactions/account/\(id)/period?startDate=\(startDateString)&endDate=\(endDateString)"

        let transactions: [Transaction] = try await networkClient.request(
            endpoint: endpoint,
            method: "GET",
            requestBody: EmptyRequest()
        )
        print(transactions)
        return transactions
    }


    // MARK: - Create Transaction

    func makeTransaction(id: Int, accountId: Int, categoryId: Int, amount: Decimal, transactionDate: Date?, comment: String?) async throws -> TransactionPut {
        struct Request: Encodable {
            let accountId: Int
            let categoryId: Int
            let amount: Decimal
            let transactionDate: String?
            let comment: String?
        }

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // Это важно, чтобы дата не смещалась!

        let dateString = transactionDate.map { formatter.string(from: $0) }

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

        print("✅ Отправленный requestBody: \(requestBody)")
        print("✅ Полученный ответ: \(result)")

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

        let transaction: Transaction = try await networkClient.request(
            endpoint: "/api/v1/transactions/\(id)",
            method: "PUT",
            requestBody: requestBody
        )

        return transaction
    }

    // MARK: - Remove Transaction

    func removeTransaction(id: Int) async throws {
        let _: EmptyResponse = try await networkClient.request<EmptyRequest, EmptyResponse>(
            endpoint: "/api/v1/transactions/\(id)",
            method: "DELETE",
            requestBody: EmptyRequest()
        )
    }
}

// MARK: - Вспомогательные Типы

//struct EmptyRequest: Encodable {}

