//
//  BankAccountsService.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 08.06.2025.
//

import Foundation

protocol BankAccountsServiceProtocol {
    func fetchBankAccount() async throws -> Accounts
    func changeBankAccount() async throws
}

class BankAccountsService: BankAccountsServiceProtocol {
    func fetchBankAccount() async throws -> Accounts {
        Accounts(id: 1, userId: 1, name: "Основной счет", balance: "1000.00", currency: "RUB", createdAt: "11.06.2004", updatedAt: "11.06.2024")
    }
    
    func changeBankAccount() async throws {
        <#code#>
    }
    
    
}
