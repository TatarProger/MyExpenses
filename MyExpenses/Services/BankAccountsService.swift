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

final class BankAccountsService: BankAccountsServiceProtocol {
    private let networkClient: NetworkClient
    private let storage: BankAccountStorage

    init(networkClient: NetworkClient, storage: BankAccountStorage) {
        self.networkClient = networkClient
        self.storage = storage
    }

    func fetchBankAcccount() async throws -> BankAccount {
        do {
            let accounts: [BankAccount] = try await networkClient.request(
                endpoint: "/api/v1/accounts",
                method: "GET",
                requestBody: EmptyRequest()
            )

            guard let firstAccount = accounts.first else {
                throw NSError(domain: "NoBankAccountFound", code: 404)
            }

            try await storage.deleteAll() 
            try await storage.save(account: firstAccount)

            return firstAccount
        } catch {
            print("⚠️ Ошибка загрузки аккаунта из сети: \(error). Пытаемся получить локально...")

            let cached = try await storage.fetchAll()
            guard let account = cached.first else {
                throw error
            }

            print(" Загружено из локального хранилища")
            return account
        }
    }

    func changeBankAccount(_ id: Int, _ name: String, _ balance: Decimal, _ currency: String) async throws -> BankAccount {
        struct Request: Encodable {
            let name: String
            let balance: String
            let currency: String

            enum CodingKeys: String, CodingKey {
                case name, balance, currency
            }

            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(name, forKey: .name)
                try container.encode(balance, forKey: .balance)
                try container.encode(currency, forKey: .currency)
            }
        }

        let balanceString = String(format: "%.2f", NSDecimalNumber(decimal: balance).doubleValue)
        let requestBody = Request(name: name, balance: balanceString, currency: currency)

        let updatedAccount: BankAccount = try await networkClient.request(
            endpoint: "/api/v1/accounts/\(id)",
            method: "PUT",
            requestBody: requestBody
        )

        try await storage.deleteAll()
        try await storage.save(account: updatedAccount)

        return updatedAccount
    }
    
    
}
