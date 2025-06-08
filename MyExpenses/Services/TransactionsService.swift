//
//  TransactionsService.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 08.06.2025.
//

import Foundation
protocol TransactionsServiceProtocol {
    func fetchTransactions() async throws
    func makeTransaction() async throws -> Transaction
    func updateTransaction() async throws -> Transaction
    func removeTransaction() async throws 
}
