//
//  AccountsResponse.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 08.06.2025.
//

import Foundation

struct AccountsResponse: Codable {
    let id: Int
    let name: String
    let balance: String
    let currency: String
    let incomeStats: [StatItem]
    let expenseStats: [StatItem]
    let createdAt: String
    let updateAt: String
}
