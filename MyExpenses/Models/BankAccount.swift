//
//  Accounts.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 07.06.2025.
//

import Foundation
struct BankAccount: Codable, Equatable {
    let id: Int
    let userId: Int
    let name: String
    let balance: Decimal
    let currency: String
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, userId, name, balance, currency, createdAt, updatedAt
    }
    
    init(id: Int, userId: Int, name: String, balance: Decimal, currency: String, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.userId = userId
        self.name = name
        self.balance = balance
        self.currency = currency
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        userId = try container.decode(Int.self, forKey: .userId)
        name = try container.decode(String.self, forKey: .name)
        
        let balanceString = try container.decode(String.self, forKey: .balance)
        guard let decimalValue = Decimal(string: balanceString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .balance,
                in: container,
                debugDescription: "Balance string is not a valid Decimal"
            )
        }
        balance = decimalValue
        
        currency = try container.decode(String.self, forKey: .currency)
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let createdAtString = try container.decode(String.self, forKey: .createdAt)
        guard let createdAtDate = dateFormatter.date(from: createdAtString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .createdAt,
                in: container,
                debugDescription: "Date string does not match format expected by formatter"
            )
        }
        createdAt = createdAtDate
        
        let updatedAtString = try container.decode(String.self, forKey: .updatedAt)
        guard let updatedAtDate = dateFormatter.date(from: updatedAtString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .updatedAt,
                in: container,
                debugDescription: "Date string does not match format expected by formatter"
            )
        }
        updatedAt = updatedAtDate
    }
}
