//
//  CategoriesService.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 08.06.2025.
//

import Foundation

protocol CategoriesServiceProtocol {
    func fetchCategories() async throws  -> [Category]
    //func
}

class CategoriesService: CategoriesServiceProtocol {
    
    private let mockCategories: [Category] = [Category(id: 1, name: "Одежда", emoji: "👕", income: .income), Category(id: 2, name: "Питомец", emoji: "🐶", income: .income), Category(id: 3, name: "Еда", emoji: "🍕", income: .outcome), Category(id: 4, name: "Квартира", emoji: "🏠", income: .outcome)]
    
    func fetchCategories() async throws -> [Category] {
        return mockCategories
    }
    
    func fetchCategories(for direction: Direction) async throws -> [Category] {
        return mockCategories.filter{$0.income == direction}
    }
}
