//
//  AccountState.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 08.06.2025.
//

import Foundation

struct AccountState: Codable {
    let id: Int
    let name: String
    let balance: String
    let currency: String
}
