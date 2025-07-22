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

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func fetchBankAcccount() async throws -> BankAccount {
        let accounts: [BankAccount] = try await networkClient.request(
            endpoint: "/api/v1/accounts",
            method: "GET",
            requestBody: EmptyRequest()
        )
        guard let firstAccount = accounts.first else {
            throw NSError(domain: "NoBankAccountFound", code: 404)
        }
        return firstAccount
    }

    // Изменяем данные конкретного аккаунта

    
    func changeBankAccount(_ id: Int, _ name: String, _ balance: Decimal, _ currency: String) async throws -> BankAccount {
        struct Request: Encodable {
            let name: String
            let balance: String
            let currency: String

            enum CodingKeys: String, CodingKey {
                case name
                case balance
                case currency
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

        return updatedAccount
    }











}
