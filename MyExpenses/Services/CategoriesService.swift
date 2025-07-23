//
//  CategoriesService.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 08.06.2025.
//

import Foundation


protocol CategoriesServiceProtocol {
    func fetchCategories() async throws -> [Category]
    func fetchCategories(for direction: Direction) async throws -> [Category]
}


final class CategoriesService: CategoriesServiceProtocol {
    private let networkClient: NetworkClient
    private let storage: CategoryStorage

    init(networkClient: NetworkClient, storage: CategoryStorage) {
        self.networkClient = networkClient
        self.storage = storage
    }

    func fetchCategories() async throws -> [Category] {
        do {
            let categories: [Category] = try await networkClient.request(
                endpoint: "/api/v1/categories",
                method: "GET",
                requestBody: EmptyRequest()
            )
            try await storage.deleteAll()
            try await storage.save(categories: categories)
            return categories
        } catch {
            print("⚠️ Failed to load categories from network: \(error). Using cached.")
            let cached = try await storage.fetchAll()
            if cached.isEmpty { throw error }
            return cached
        }
    }

    func fetchCategories(for direction: Direction) async throws -> [Category] {
        let all = try await fetchCategories()
        return all.filter { $0.income == direction }
    }
}
