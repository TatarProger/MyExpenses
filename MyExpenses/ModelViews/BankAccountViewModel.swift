//
//  BankAccountViewModel.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 27.06.2025.
//

import SwiftUI
//
//@MainActor
//class BankAccountViewModel: ObservableObject {
//    @Published var account: BankAccount?
//    @Published var editedBalance: String = ""
//    @Published var editedCurrency: String = ""
//    @Published var isBalanceHidden: Bool = false
//
//    private let service: BankAccountsServiceProtocol
//
//    init(service: BankAccountsServiceProtocol) {
//        self.service = service
//        Task {
//            await fetchAccount()
//        }
//    }
//
//    func fetchAccount() async {
//        do {
//            let fetched = try await service.fetchBankAcccount()
//            self.account = fetched
//        } catch {
//            print("Ошибка загрузки аккаунта: \(error)")
//        }
//    }
//
//    func enterEditMode() {
//        if let account = account {
//            self.editedBalance = "\(account.balance)"
//            self.editedCurrency = account.currency
//        }
//    }
//
//    func saveChanges() async {
//        guard let id = account?.id,
//              let balance = Decimal(string: editedBalance.replacingOccurrences(of: ",", with: ".")) else { return }
//
//        do {
//            let updated = try await service.changeBankAccount(id, "Основной счет", balance, editedCurrency)
//            self.account = updated
//        } catch {
//            print("Ошибка при сохранении: \(error)")
//        }
//    }
//}


@MainActor
class BankAccountViewModel: ObservableObject {
    @Published var account: BankAccount?
    @Published var editedBalance: String = ""
    @Published var editedCurrency: String = ""
    @Published var isBalanceHidden: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

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
}
