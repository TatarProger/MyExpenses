//
//  TransactionViewModel.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 27.06.2025.
//

import SwiftUI

class TransactionViewModel: ObservableObject {
    let accountId: Int
    let direction: Direction
    @Published var total: Decimal = 0
    @Published var transactions:[Transaction] = []
    private var service = TransactionsService(categoriesService: CategoriesService())
    
    init(accountId: Int, direction: Direction, transactionService: TransactionsService) {
        self.accountId = accountId
        self.direction = direction
        self.service = transactionService
    }
    
    func loadTransactions() async throws {
        let calendar = Calendar.current
        let now = Date()
        let stratOfDay = calendar.startOfDay(for: now)
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: now) ?? Date()
        let transactionsList = try await service.fetchTransactionsForPeriod(accountId, stratOfDay, endOfDay).filter {$0.category.income == direction}
        await MainActor.run {
            transactions = transactionsList
            total = transactionsList.map { $0.amount }.reduce(0, +)
        }
    }
    
}
