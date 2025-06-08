//
//  AccountHistory.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 08.06.2025.
//

import Foundation

struct AccountHistory: Codable {
    enum Change: String {
        case creation = "CREATION"
        case modification = "MODIFICATION"
    }
    
    let id: Int
    let accountId: Int
    let changeType: String
    let previosState: AccountState
    let newState: AccountState
    let changeTimestamp: String
    let createdAt: String
}
