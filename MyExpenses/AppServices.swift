//
//  AppServices.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 10.07.2025.
//

final class AppServices {
    static let shared = AppServices()

    let categoriesService = CategoriesService()
    let transactionsService: TransactionsService
    let bankAccountsService = BankAccountsService()

    private init() {
        transactionsService = TransactionsService(categoriesService: categoriesService)
    }
}
