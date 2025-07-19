//
//  TransactionEditorViewModel.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 12.07.2025.
//

import SwiftUI

class TransactionEditorViewModel: ObservableObject {
    enum Mode {
        case create
        case edit(Transaction)
    }

    @Published var selectedCategory: Category?
    @Published var amount: String = ""
    @Published var date: Date = Date()
    @Published var comment: String = ""
    @Published var showAlert = false
    @Published var availableCategories: [Category] = []

    let mode: Mode
    let direction: Direction
    let transactionService: TransactionsServiceProtocol
    let accountService: BankAccountsServiceProtocol
    let categoriesService: CategoriesService

    var onReload: (() async -> Void)?

    init(mode: Mode,
         transactionService: TransactionsServiceProtocol,
         accountService: BankAccountsServiceProtocol,
         categoriesService: CategoriesService,
         direction: Direction) {
        self.mode = mode
        self.transactionService = transactionService
        self.accountService = accountService
        self.categoriesService = categoriesService
        self.direction = direction

        if case let .edit(transaction) = mode {
            selectedCategory = transaction.category
            amount = "\(transaction.amount)"
            date = transaction.transactionDate ?? Date()
            comment = transaction.comment ?? ""
        }

        Task {
            await loadCategories()
        }
    }

    var isValid: Bool {
        selectedCategory != nil &&
        !amount.isEmpty &&
        Decimal(string: amount.replacingOccurrences(of: ",", with: ".")) != nil
    }

    func loadCategories() async {
        do {
            let categories = try await categoriesService.fetchCategories(for: direction)
            await MainActor.run {
                self.availableCategories = categories
            }
        } catch {
            print("Ошибка загрузки категорий: \(error)")
        }
    }

    func handleSubmit(completion: @escaping () -> Void) {
        Task {
            do {
                guard let category = selectedCategory else { return }
                let formattedAmount = Decimal(string: amount.replacingOccurrences(of: ",", with: ".")) ?? 0
                let localDate = convertToLocal(date)

                let mainAccount = try await accountService.fetchBankAcccount()

                var updatedAccount: BankAccount?

                switch mode {
                case .edit(let transaction):
                    _ = try await transactionService.updateTransaction(
                        transaction.id,
                        transaction.account.id,
                        category.id,
                        amount: formattedAmount,
                        localDate,
                        comment
                    )

                    let newBalance = mainAccount.balance - transaction.amount + formattedAmount
                    updatedAccount = try await accountService.changeBankAccount(mainAccount.id, mainAccount.name, newBalance, mainAccount.currency)

                case .create:
                    _ = try await transactionService.makeTransaction(
                        id: mainAccount.id,
                        accountId: mainAccount.id,
                        categoryId: category.id,
                        amount: formattedAmount,
                        transactionDate: localDate,
                        comment: comment
                    )

                    let newBalance = mainAccount.balance + formattedAmount
                    updatedAccount = try await accountService.changeBankAccount(mainAccount.id, mainAccount.name, newBalance, mainAccount.currency)
                }

                print("✅ Баланс обновлен: \(updatedAccount?.balance ?? 0)")

                await onReload?()
                await MainActor.run { completion() }

            } catch {
                print("Ошибка сохранения: \(error)")
            }
        }
    }


    private func convertToLocal(_ date: Date) -> Date {
        let timezoneOffset = Double(TimeZone.current.secondsFromGMT(for: date))
        return date.addingTimeInterval(timezoneOffset)
    }


    func deleteTransaction(completion: @escaping () -> Void) {
        if case let .edit(transaction) = mode {
            Task {
                do {
                    try await transactionService.removeTransaction(id: transaction.id)
                    await onReload?()
                    await MainActor.run { completion() }
                } catch {
                    print("Ошибка удаления: \(error)")
                }
            }
        }
    }
    
//    func dateFormatted(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        return formatter.string(from: date)
//    }
//    
//    func timeFormatted(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.timeStyle = .short
//        return formatter.string(from: date)
//    }
    
    func dateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    func timeFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    
    private var decimalSeparator: String {
        Locale.current.decimalSeparator ?? ","
    }

    func updateAmountInput(_ input: String) {
        let allowedCharacters = CharacterSet.decimalDigits
        let separator = decimalSeparator

        var result = ""
        var separatorUsed = false

        for char in input {
            if char.unicodeScalars.allSatisfy(allowedCharacters.contains) {
                result.append(char)
            } else if String(char) == separator, !separatorUsed {
                result.append(char)
                separatorUsed = true
            }
        }

        if amount != result {
            amount = result
        }
    }
    
}
