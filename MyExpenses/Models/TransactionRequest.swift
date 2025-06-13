//
//  TransactionResponse.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 10.06.2025.
//

import Foundation
struct TransactionRequest: Codable {
    let accountId: Int
    let categoryId: Int
    let amount: Decimal
    let transactionDate: Date
    let comment: String?
    
    enum CodingKeys: String, CodingKey {
        case accountId, categoryId, amount, transactionDate, comment
    }
    
    init(accountId: Int, categoryId: Int, amount: Decimal, transactionDate: Date, comment: String? = nil) {
        self.accountId = accountId
        self.categoryId = categoryId
        self.amount = amount
        self.transactionDate = transactionDate
        self.comment = comment
    }   
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        accountId = try container.decode(Int.self, forKey: .accountId)
        categoryId = try container.decode(Int.self, forKey: .categoryId)
        comment = try container.decode(String.self, forKey: .comment)
        let amountString = try container.decode(String.self, forKey: .amount)
        guard let decimalAmount = Decimal(string: amountString) else {
            throw DecodingError.dataCorruptedError(forKey: .amount, in: container, debugDescription: "amount string is not a valid Decimal")
        }
        
        amount = decimalAmount
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let transactionDateString = try container.decode(String.self, forKey: .transactionDate)
        guard let transactionDateDate = dateFormatter.date(from: transactionDateString) else {
            throw DecodingError.dataCorruptedError(forKey: .transactionDate, in: container, debugDescription: "transactionDate string does not match format expected by formatter")
        }
        
        transactionDate = transactionDateDate
        
    }
}
