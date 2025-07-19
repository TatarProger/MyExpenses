//
//  AppServices.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 10.07.2025.
//

import Foundation

final class AppServices {
    static let shared = AppServices()

    let categoriesService = CategoriesService(networkClient: NetworkClient(baseURL: URL(string: "https://shmr-finance.ru/api/v1")!, bearerToken: "jXK6tFet5YGBbfYliKp2raJX"))
    let transactionsService: TransactionsService
    let bankAccountsService = BankAccountsService(networkClient: NetworkClient(baseURL: URL(string: "https://shmr-finance.ru/api/v1")!, bearerToken: "jXK6tFet5YGBbfYliKp2raJX"))

    private init() {
        transactionsService = TransactionsService(networkClient: NetworkClient(baseURL: URL(string: "https://shmr-finance.ru/api/v1")!, bearerToken: "jXK6tFet5YGBbfYliKp2raJX"))
    }
}
