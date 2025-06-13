//
//  BankAccountsService.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 08.06.2025.
//

import Foundation

protocol BankAccountsServiceProtocol {
    func fetchBankAcccount() async throws -> BankAccount
    func changeBankAccount(_ id: Int, _ name: String, _ balance: Decimal, _ currency: String) async throws -> BankAccount
}

class BankAccountsService: BankAccountsServiceProtocol {
    private var bankAccounts = [BankAccount(id: 1, userId: 1, name: "Основной счет", balance: 1000.00, currency: "RUB", createdAt: ISO8601DateFormatter().date(from: "2004-06-11T00:00:00.000Z") ?? Date(), updatedAt: ISO8601DateFormatter().date(from: "2004-06-11T00:00:00.000Z") ?? Date())]
    
    
    func changeBankAccount(_ id: Int, _ name: String, _ balance: Decimal, _ currency: String) async throws -> BankAccount {
        let bankAccount = bankAccounts.first(where: ){$0.id == id}
        
        return BankAccount(id: id, userId: bankAccount?.userId ?? 0, name: name, balance: balance, currency: currency, createdAt: bankAccount?.createdAt ?? Date(), updatedAt: bankAccount?.updatedAt ?? Date())
    }
    
    func fetchBankAcccount() async throws -> BankAccount {
        bankAccounts[0]
    }
    
}
