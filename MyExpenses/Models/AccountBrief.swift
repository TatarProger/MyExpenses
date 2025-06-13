//
//  AccountBrief.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 11.06.2025.
//

import Foundation
struct AccountBrief: Codable, Equatable {
    let id: Int
    let name: String
    let balance: Decimal
    let currency: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, balance, currency
    }
    
    init(id: Int, name: String, balance: Decimal, currency: String) {
        self.id = id
        self.name = name
        self.balance = balance
        self.currency = currency
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
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
    }
}
