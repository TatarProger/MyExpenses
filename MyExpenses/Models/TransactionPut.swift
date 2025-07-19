//
//  TransactionPut.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 11.06.2025.
//

import Foundation



struct TransactionPut: Codable {
    let id: Int
    let accountId: Int
    let categoryId: Int
    let amount: Decimal
    let transactionDate: Date?
    let comment: String?

    enum CodingKeys: String, CodingKey {
        case id
        case accountId
        case categoryId
        case amount
        case transactionDate
        case comment
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        accountId = try container.decode(Int.self, forKey: .accountId)
        categoryId = try container.decode(Int.self, forKey: .categoryId)

        // Универсальный парсинг amount из строки или числа:
        if let amountString = try? container.decode(String.self, forKey: .amount),
           let amountDecimal = Decimal(string: amountString) {
            amount = amountDecimal
        } else {
            amount = try container.decode(Decimal.self, forKey: .amount)
        }

        // Парсинг даты с поддержкой null:
        if let dateString = try? container.decode(String.self, forKey: .transactionDate) {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            transactionDate = formatter.date(from: dateString)
        } else {
            transactionDate = nil
        }

        comment = try container.decodeIfPresent(String.self, forKey: .comment)
    }
}
