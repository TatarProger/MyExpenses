//
//  AccountHistoryResponse.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 08.06.2025.
//

import Foundation

struct AccountHistoryResponse: Codable {
    let accountId: Int
    let accountName: String
    let currency: String
    let currentBalance: String
    let history: [AccountHistory]
}
