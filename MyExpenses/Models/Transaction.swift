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

        print("✅ Transaction decoded: id=\(id), amount=\(amount), category=\(category.name)")
    }

//    private static func parseISODate(_ dateString: String?) -> Date? {
//        guard let dateString = dateString else { return nil }
//        let formatter = ISO8601DateFormatter()
//        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//        return formatter.date(from: dateString)
//    }
    
    private static func parseISODate(_ dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // Это ключевой момент
        return formatter.date(from: dateString)
    }

}
