//
//  BankAccountViewModel.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 27.06.2025.
//

import SwiftUI

@MainActor
class BankAccountViewModel: ObservableObject {
    @Published var account: BankAccount?
    @Published var editedBalance: String = ""
    @Published var editedCurrency: String = ""
    @Published var isBalanceHidden: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var dailyBalances: [DailyBalance] = []

    private let transactionsService = AppServices.shared.transactionsService


    private let service: BankAccountsServiceProtocol

    init(service: BankAccountsServiceProtocol = AppServices.shared.bankAccountsService) {
        self.service = service
        Task {
            await fetchAccount()
        }
    }

    func fetchAccount() async {
        isLoading = true
        errorMessage = nil
        do {
            let fetched = try await service.fetchBankAcccount()
            self.account = fetched
            await loadTransactionsForChart()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func enterEditMode() {
        if let account = account {
            editedBalance = "\(account.balance)"
            editedCurrency = account.currency
        }
    }

    func saveChanges() async {
        guard let id = account?.id,
              let balance = Decimal(string: editedBalance.replacingOccurrences(of: ",", with: ".")) else {
            errorMessage = "Неверное значение баланса"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let updated = try await service.changeBankAccount(id, "Основной счет", balance, editedCurrency)
            self.account = updated
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
    
    func loadTransactionsForChart() async {
        guard let account = account else { return }

        let calendar = Calendar.current
        let endDate = calendar.startOfDay(for: Date())
        let startDate = calendar.date(byAdding: .day, value: -29, to: endDate)!

        do {
            let transactions = try await transactionsService.fetchTransactionsForPeriod(account.id, startDate, endDate)
            let grouped = Dictionary(grouping: transactions) { tx in
                calendar.startOfDay(for: tx.transactionDate ?? tx.createdAt)
            }

            let days = (0..<30).map { offset -> DailyBalance in
                let date = calendar.date(byAdding: .day, value: -offset, to: endDate)!
                let dayTxs = grouped[date] ?? []

                let sum: Decimal = dayTxs.reduce(0) { acc, tx in
                    let sign: Decimal = tx.category.income == .income ? 1 : -1
                    return acc + tx.amount * sign
                }

                return DailyBalance(
                    date: date,
                    balance: (sum as NSDecimalNumber).doubleValue
                )
            }

            dailyBalances = days.reversed()
        } catch {
            errorMessage = "Не удалось загрузить транзакции: \(error.localizedDescription)"
        }
    }

}
