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
    func fetchCategories() async throws -> [Category] {
        [Category(id: 1, name: "Одежда", emoji: "👕", isIncome: true),
         Category(id: 2, name: "Питомец", emoji: "🐶", isIncome: true),
         Category(id: 3, name: "Еда", emoji: "🍕", isIncome: true),
         Category(id: 4, name: "Квартира", emoji: "🏠", isIncome: true)]
        
    }
    
    
}
