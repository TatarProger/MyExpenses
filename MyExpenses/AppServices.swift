//
//  AppServices.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 10.07.2025.
//

import Foundation
import SwiftData





@MainActor
final class AppServices {
    static let shared = AppServices()

    let categoriesService: CategoriesService
    let transactionsService: TransactionsService
    let bankAccountsService: BankAccountsService

    private init() {

        let networkClient = NetworkClient(
            baseURL: URL(string: "https://shmr-finance.ru/api/v1")!,
            bearerToken: "jXK6tFet5YGBbfYliKp2raJX"
        )


        let container = try! ModelContainer(
            for: TransactionEntity.self,
                 BankAccountEntity.self,
                 CategoryEntity.self
        )


        let transactionStorage = TransactionStorage(modelContainer: container)
        let bankAccountStorage = BankAccountStorage(modelContainer: container)
        let categoryStorage = CategoryStorage(modelContainer: container)


        self.transactionsService = TransactionsService(
            networkClient: networkClient,
            storage: transactionStorage
        )

        self.bankAccountsService = BankAccountsService(
            networkClient: networkClient,
            storage: bankAccountStorage
        )

        self.categoriesService = CategoriesService(
            networkClient: networkClient,
            storage: categoryStorage
        )
    }
}
