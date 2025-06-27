//
//  Untitled.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 27.06.2025.
//

import SwiftUI

@MainActor
class TransactionHistoryViewModel: ObservableObject {
    enum SortType: String, CaseIterable, Identifiable {
        case byDate = "По дате"
        case byAmount = "По сумме"
        
        var id: String { self.rawValue }
    }

    let accountId: Int
    let direction: Direction
    private let service = TransactionsService()

    @Published var transactions: [Transaction] = []
    @Published var startDate: Date {
        didSet {
            if startDate > endDate {
                endDate = startDate
            }
            Task { await loadTransactions() }
        }
    }

    @Published var endDate: Date {
        didSet {
            if endDate < startDate {
                startDate = endDate
            }
            Task { await loadTransactions() }
        }
    }
    @Published var total: Decimal = 0
    @Published var sortType: SortType = .byDate

    private let calendar = Calendar.current

    init(accountId: Int, direction: Direction) {
        self.accountId = accountId
        self.direction = direction

        let now = Date()
        let end = calendar.startOfDay(for: now)
        self.endDate = end
        self.startDate = calendar.date(byAdding: .month, value: -1, to: end) ?? end
    }

    func loadTransactions() async {
        let startDateTime = calendar.startOfDay(for: startDate)
        let endDateTime = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endDate) ?? endDate

        do {
            let all = try await service.fetchTransactionsForPeriod(accountId, startDateTime, endDateTime)
            let filtered = all.filter { $0.category.income == direction }

            let sorted: [Transaction]
            switch sortType {
            case .byDate:
                sorted = filtered.sorted { ($0.transactionDate ?? .distantPast) > ($1.transactionDate ?? .distantPast) }
            case .byAmount:
                sorted = filtered.sorted { $0.amount > $1.amount }
            }

            transactions = sorted
            total = sorted.map { $0.amount }.reduce(0, +)
        } catch {
            print("Ошибка загрузки транзакций: \(error)")
        }
    }
}
