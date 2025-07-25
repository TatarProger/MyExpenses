//
//  Transaction.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 07.06.2025.
//

import Foundation

struct Transaction: Identifiable, Decodable {
    let id: Int
    let account: AccountBrief
    let category: Category
    let amount: Decimal
    let transactionDate: Date?
    let comment: String?
    let createdAt: Date
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id, account, category, amount, transactionDate, comment, createdAt, updatedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        account = try container.decode(AccountBrief.self, forKey: .account)
        category = try container.decode(Category.self, forKey: .category)

        let amountString = try container.decode(String.self, forKey: .amount)
        amount = Decimal(string: amountString) ?? 0

        transactionDate = Self.parseISODate(try? container.decodeIfPresent(String.self, forKey: .transactionDate))
        createdAt = Self.parseISODate(try container.decode(String.self, forKey: .createdAt)) ?? Date()
        updatedAt = Self.parseISODate(try container.decode(String.self, forKey: .updatedAt)) ?? Date()

        comment = try container.decodeIfPresent(String.self, forKey: .comment)

        print("✅ Transaction decoded: id=\(id), amount=\(amount), category=\(category.name), \(comment ?? "nil"), \(transactionDate?.description ?? "nil")")
    }
    
    private static func parseISODate(_ dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }
        
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoFormatter.date(from: dateString) {
            return date
        }

        isoFormatter.formatOptions = [.withInternetDateTime]
        return isoFormatter.date(from: dateString)
    }
}


// MARK: - Инициализация из TransactionEntity (локальное хранилище)

extension Transaction {
    init(from entity: TransactionEntity) {
        self.id = entity.id

        self.account = AccountBrief(
            id: entity.accountId,
            name: entity.accountName,
            balance: Decimal(entity.accountBalance),
            currency: entity.accountCurrency
        )

        self.category = Category(
            id: entity.categoryId,
            name: entity.categoryName,
            emoji: Character(entity.categoryEmoji),
            income: entity.isIncome ? .income : .outcome
        )

        self.amount = Decimal(entity.amount)
        self.transactionDate = entity.transactionDate
        self.comment = entity.comment
        self.createdAt = entity.createdAt
        self.updatedAt = entity.updatedAt
    }
    
    
}


extension Transaction {
    init(
        id: Int,
        account: AccountBrief,
        category: Category,
        amount: Decimal,
        transactionDate: Date?,
        comment: String?,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.account = account
        self.category = category
        self.amount = amount
        self.transactionDate = transactionDate
        self.comment = comment
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
