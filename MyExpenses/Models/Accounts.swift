//
//  Accounts.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 07.06.2025.
//

import Foundation
struct Accounts: Codable {
    let id: Int
    let userId: Int
    let name: String
    let balance: String
    let currency: String
    let createdAt: String
    let updatedAt: String
}
