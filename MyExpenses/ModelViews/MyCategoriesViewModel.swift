//
//  CategoriesViewModel.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 04.07.2025.
//

import SwiftUI

//@MainActor
//class MyCategoriesViewModel: ObservableObject {
//    @Published var searchText: String = ""
//    @Published var transactions: [Transaction] = []
//    @Published var isLoading: Bool = false
//
//    let service = TransactionsService(categoriesService: CategoriesService())
//
//    var filteredTransactions: [Transaction] {
//        guard !searchText.isEmpty else { return transactions }
//
//        let query = searchText.lowercased()
//
//        return transactions
//            .map { transaction in
//                let name = transaction.category.name.lowercased()
//                let comment = (transaction.comment ?? "").lowercased()
//                let minDistance = min(
//                    fuzzySearch(query, name),
//                    fuzzySearch(query, comment)
//                )
//                return (transaction, minDistance)
//            }
//            .filter { $0.1 <= 2 }
//            .sorted { $0.1 < $1.1 }
//            .map { $0.0 }
//    }
//
//    func loadTransactions() async {
//        isLoading = true
//        do {
//            let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
//            let endDate = Date()
//            transactions = try await service.fetchTransactionsForPeriod(1, startDate, endDate)
//        } catch {
//            print("Ошибка загрузки транзакций: \(error.localizedDescription)")
//        }
//        isLoading = false
//    }
//
//    private func fuzzySearch(_ aStr: String, _ bStr: String) -> Int {
//        let a = Array(aStr)
//        let b = Array(bStr)
//
//        let m = a.count
//        let n = b.count
//
//        var matrix = Array(repeating: Array(repeating: 0, count: n + 1), count: m + 1)
//
//        for i in 0...m { matrix[i][0] = i }
//        for j in 0...n { matrix[0][j] = j }
//
//        for i in 1...m {
//            for j in 1...n {
//                if a[i - 1] == b[j - 1] {
//                    matrix[i][j] = matrix[i - 1][j - 1]
//                } else {
//                    matrix[i][j] = min(
//                        matrix[i - 1][j] + 1,
//                        matrix[i][j - 1] + 1,
//                        matrix[i - 1][j - 1] + 1
//                    )
//                }
//            }
//        }
//
//        return matrix[m][n]
//    }
//}

@MainActor
class MyCategoriesViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var categories: [Category] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    private let service: CategoriesServiceProtocol
    
    init(service: CategoriesServiceProtocol = AppServices.shared.categoriesService) {
        self.service = service
    }
    
    var filteredCategories: [Category] {
        guard !searchText.isEmpty else { return categories }
        
        let query = searchText.lowercased()
        
        return categories
            .map { category in
                let name = category.name.lowercased()
                let minDistance = fuzzySearch(query, name)
                return (category, minDistance)
            }
            .filter { $0.1 <= 2 }
            .sorted { $0.1 < $1.1 }
            .map { $0.0 }
    }
    
//    func loadCategories() async {
//        isLoading = true
//        do {
//            categories = try await service.fetchCategories()
//        } catch {
//            print("Ошибка загрузки категорий: \(error.localizedDescription)")
//        }
//        isLoading = false
//    }
    
    @MainActor
    func loadCategories() async {
        isLoading = true
        errorMessage = nil
        do {
            let categories = try await service.fetchCategories()
            self.categories = categories
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    
    private func fuzzySearch(_ aStr: String, _ bStr: String) -> Int {
        let a = Array(aStr)
        let b = Array(bStr)
        
        let m = a.count
        let n = b.count
        
        var matrix = Array(repeating: Array(repeating: 0, count: n + 1), count: m + 1)
        
        for i in 0...m { matrix[i][0] = i }
        for j in 0...n { matrix[0][j] = j }
        
        for i in 1...m {
            for j in 1...n {
                if a[i - 1] == b[j - 1] {
                    matrix[i][j] = matrix[i - 1][j - 1]
                } else {
                    matrix[i][j] = min(
                        matrix[i - 1][j] + 1,
                        matrix[i][j - 1] + 1,
                        matrix[i - 1][j - 1] + 1
                    )
                }
            }
        }
        
        return matrix[m][n]
    }
}
