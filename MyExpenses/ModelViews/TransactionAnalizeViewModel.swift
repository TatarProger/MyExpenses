//
//  TransactionAnalizeViewModel.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 11.07.2025.
//

import SwiftUI
import PieChart
//@MainActor
//class TransactionAnalizeViewModel: ObservableObject {
//    enum SortType: String, CaseIterable, Identifiable {
//        case byDate = "По дате"
//        case byAmount = "По сумме"
//        
//        var id: String { self.rawValue }
//    }
//
//    let accountId: Int
//    let direction: Direction
//    private var service = TransactionsService(categoriesService: CategoriesService())
//    
//    var triggerReload: (() -> Void)?
//
//
//    @Published var transactions: [Transaction] = []
//    @Published var startDate: Date {
//        didSet {
//            if startDate > endDate {
//                endDate = startDate
//            }
//            triggerReload?()
//            Task { await loadTransactions() }
//        }
//    }
//
//    @Published var endDate: Date {
//        didSet {
//            if endDate < startDate {
//                startDate = endDate
//            }
//            triggerReload?()
//            Task { await loadTransactions() }
//        }
//    }
//    @Published var total: Decimal = 0
//    @Published var sortType: SortType = .byDate
//
//    private let calendar = Calendar.current
//
//    init(accountId: Int, direction: Direction, transactionService: TransactionsService) {
//        self.accountId = accountId
//        self.direction = direction
//        self.service = transactionService
//
//        let now = Date()
//        let end = calendar.startOfDay(for: now)
//        self.endDate = end
//        self.startDate = calendar.date(byAdding: .month, value: -1, to: end) ?? end
//    }
//
//    func loadTransactions() async {
//        let startDateTime = calendar.startOfDay(for: startDate)
//        let endDateTime = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endDate) ?? endDate
//
//        do {
//            let all = try await service.fetchTransactionsForPeriod(accountId, startDateTime, endDateTime)
//            let filtered = all.filter { $0.category.income == direction }
//
//            let sorted: [Transaction]
//            switch sortType {
//            case .byDate:
//                sorted = filtered.sorted { ($0.transactionDate ?? .distantPast) > ($1.transactionDate ?? .distantPast) }
//            case .byAmount:
//                sorted = filtered.sorted { $0.amount > $1.amount }
//            }
//
//            transactions = sorted
//            total = sorted.map { $0.amount }.reduce(0, +)
//        } catch {
//            print("Ошибка загрузки транзакций: \(error)")
//        }
//    }
//    
//    func dateFormatted(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "ru_RU")
//        formatter.dateFormat = "d MMMM yyyy"
//        return formatter.string(from: date)
//    }
//
//    
//    
//    func timeFormatted(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//        return formatter.string(from: date)
//    }
//}


//@MainActor
//class TransactionAnalizeViewModel: ObservableObject {
//    enum SortType: String, CaseIterable, Identifiable {
//        case byDate = "По дате"
//        case byAmount = "По сумме"
//
//        var id: String { self.rawValue }
//    }
//
//    let accountId: Int
//    let direction: Direction
//
//    private let service: TransactionsService
//
//    var triggerReload: (() -> Void)?
//
//    @Published var transactions: [Transaction] = []
//    @Published var startDate: Date {
//        didSet {
//            if startDate > endDate {
//                endDate = startDate
//            }
//            triggerReload?()
//            Task { await loadTransactions() }
//        }
//    }
//
//    @Published var endDate: Date {
//        didSet {
//            if endDate < startDate {
//                startDate = endDate
//            }
//            triggerReload?()
//            Task { await loadTransactions() }
//        }
//    }
//
//    @Published var total: Decimal = 0
//    @Published var sortType: SortType = .byDate
//    @Published var isLoading: Bool = false
//    @Published var errorMessage: String?
//
//    private let calendar = Calendar.current
//
//    init(accountId: Int, direction: Direction, service: TransactionsService = AppServices.shared.transactionsService) {
//        self.accountId = accountId
//        self.direction = direction
//        self.service = service
//
//        let now = Date()
//        let end = calendar.startOfDay(for: now)
//        self.endDate = end
//        self.startDate = calendar.date(byAdding: .month, value: -1, to: end) ?? end
//    }
//
//    func loadTransactions() async {
//        let startDateTime = calendar.startOfDay(for: startDate)
//        let endDateTime = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endDate) ?? endDate
//
//        isLoading = true
//        errorMessage = nil
//
//        do {
//            let all = try await service.fetchTransactionsForPeriod(accountId, startDateTime, endDateTime)
//            let filtered = all.filter { $0.category.income == direction }
//
//            let sorted: [Transaction]
//            switch sortType {
//            case .byDate:
//                sorted = filtered.sorted { ($0.transactionDate ?? .distantPast) > ($1.transactionDate ?? .distantPast) }
//            case .byAmount:
//                sorted = filtered.sorted { $0.amount > $1.amount }
//            }
//
//            transactions = sorted
//            total = sorted.reduce(Decimal(0)) { $0 + $1.amount }
//        } catch {
//            errorMessage = error.localizedDescription
//        }
//
//        isLoading = false
//    }
//
//    func dateFormatted(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "ru_RU")
//        formatter.dateFormat = "d MMMM yyyy"
//        return formatter.string(from: date)
//    }
//
//    func timeFormatted(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//        return formatter.string(from: date)
//    }
//}
//
extension TransactionAnalizeViewModel {
    var pieChartEntities: [PieChartEntity] {
        guard total > 0 else { return [] }
        let grouped = Dictionary(grouping: transactions, by: { $0.category.name })

        return grouped.map { (key, value) in
            let sum = value.reduce(Decimal(0)) { $0 + $1.amount }
            let percent = (NSDecimalNumber(decimal: sum).doubleValue / NSDecimalNumber(decimal: total).doubleValue) * 100
            return PieChartEntity(value: sum, label: key, percent: percent)
        }
        .sorted { $0.value > $1.value }
    }
}

//
//
//extension TransactionAnalizeViewModel {
//    func percent(for transaction: Transaction) -> Double {
//        guard total > 0 else { return 0 }
//        let amount = NSDecimalNumber(decimal: transaction.amount).doubleValue
//        let totalValue = NSDecimalNumber(decimal: total).doubleValue
//        return (amount / totalValue) * 100
//    }
//}

@MainActor
class TransactionAnalizeViewModel: ObservableObject {
    enum SortType: String, CaseIterable, Identifiable {
        case byDate = "По дате"
        case byAmount = "По сумме"
        var id: String { self.rawValue }
    }

    let accountId: Int
    let direction: Direction
    private let service: TransactionsService
    var triggerReload: (() -> Void)?

    @Published var transactions: [Transaction] = []
    @Published var startDate: Date {
        didSet {
            if startDate > endDate {
                endDate = startDate
            }
            triggerReload?()
            Task { await loadTransactions() }
        }
    }
    @Published var endDate: Date {
        didSet {
            if endDate < startDate {
                startDate = endDate
            }
            triggerReload?()
            Task { await loadTransactions() }
        }
    }
    @Published var total: Decimal = 0
    @Published var sortType: SortType = .byDate
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let calendar = Calendar.current

    init(accountId: Int, direction: Direction, service: TransactionsService = AppServices.shared.transactionsService) {
        self.accountId = accountId
        self.direction = direction
        self.service = service

        let now = Date()
        let end = calendar.startOfDay(for: now)
        self.endDate = end
        self.startDate = calendar.date(byAdding: .month, value: -1, to: end) ?? end
    }

    func loadTransactions() async {
        let startDateTime = calendar.startOfDay(for: startDate)
        let endDateTime = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endDate) ?? endDate

        isLoading = true
        errorMessage = nil

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
            calculateTotal()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    /// Считает общий total
    private func calculateTotal() {
        total = transactions.reduce(Decimal(0)) { $0 + $1.amount }
    }

    /// Возвращает процент от общего total для транзакции
    func percent(for transaction: Transaction) -> Double {
        guard total > 0 else { return 0 }
        let amount = NSDecimalNumber(decimal: transaction.amount).doubleValue
        let totalValue = NSDecimalNumber(decimal: total).doubleValue
        return (amount / totalValue) * 100
    }
}
