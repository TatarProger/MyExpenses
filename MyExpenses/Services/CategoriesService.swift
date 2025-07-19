//
//  CategoriesService.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 08.06.2025.
//

import Foundation

//protocol CategoriesServiceProtocol {
//    func fetchCategories() async throws  -> [Category]
//    //func
//}
//
//class CategoriesService: CategoriesServiceProtocol {
//    
//    private let mockCategories: [Category] = [Category(id: 1, name: "Питомцы", emoji: "🐶", income: .outcome), Category(id: 3, name: "Одежда", emoji: "👗", income: .outcome), Category(id: 4, name: "Фриланс", emoji: "🧑‍💻", income: .income), Category(id: 5, name: "Продукты", emoji: "🛒", income: .outcome), Category(id: 6, name: "Бонус", emoji: "🎉", income: .income), Category(id: 7, name: "Транспорт", emoji: "🚗", income: .outcome), Category(id: 8, name: "Проценты", emoji: "🏦", income: .income), Category(id: 9, name: "Кафе", emoji: "☕️", income: .outcome), Category(id: 10, name: "Доп. работа", emoji: "💼", income: .income)]
//    
//    func fetchCategories() async throws -> [Category] {
//        return mockCategories
//    }
//    
//    func fetchCategories(for direction: Direction) async throws -> [Category] {
//        return mockCategories.filter{$0.income == direction}
//    }
//}





protocol CategoriesServiceProtocol {
    func fetchCategories() async throws -> [Category]
    func fetchCategories(for direction: Direction) async throws -> [Category]
}

class CategoriesService: CategoriesServiceProtocol {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func fetchCategories() async throws -> [Category] {
        let categories: [Category] = try await networkClient.request(
            endpoint: "/api/v1/categories",
            method: "GET",
            requestBody: EmptyRequest()
        )
        return categories
    }

    func fetchCategories(for direction: Direction) async throws -> [Category] {
        let categories = try await fetchCategories()
        return categories.filter { $0.income == direction }
    }
}
