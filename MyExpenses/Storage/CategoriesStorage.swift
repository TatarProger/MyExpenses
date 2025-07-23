//
//  CategoriesStorage.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 23.07.2025.
//
import Foundation
import SwiftData

@MainActor
final class CategoryStorage {
    private let modelContainer: ModelContainer

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    func save(categories: [Category]) throws {
        let context = modelContainer.mainContext

        for category in categories {
            let categoryID = category.id

            let fetchDescriptor = FetchDescriptor<CategoryEntity>(
                predicate: #Predicate<CategoryEntity> { $0.id == categoryID }
            )

            if let existing = try context.fetch(fetchDescriptor).first {
                existing.name = category.name
                existing.emoji = String(category.emoji)
                existing.income = category.income
            } else {
                let newEntity = CategoryEntity(
                    id: category.id,
                    name: category.name,
                    emoji: String(category.emoji),
                    income: category.income
                )
                context.insert(newEntity)
            }
        }

        try context.save()
    }

    func fetchAll() throws -> [Category] {
        let context = modelContainer.mainContext
        let entities = try context.fetch(FetchDescriptor<CategoryEntity>())
        return entities.map {
            Category(
                id: $0.id,
                name: $0.name,
                emoji: Character($0.emoji),
                income: $0.income
            )
        }
    }

    // Получение категорий по направлению (income / outcome)
    func fetch(by direction: Direction) throws -> [Category] {
        let context = modelContainer.mainContext

        let predicate = #Predicate<CategoryEntity> {
            $0.income == direction
        }

        let entities = try context.fetch(FetchDescriptor<CategoryEntity>(predicate: predicate))
        return entities.map {
            Category(
                id: $0.id,
                name: $0.name,
                emoji: Character($0.emoji),
                income: $0.income
            )
        }
    }

    func deleteAll() throws {
        let context = modelContainer.mainContext
        let allEntities = try context.fetch(FetchDescriptor<CategoryEntity>())
        allEntities.forEach { context.delete($0) }
        try context.save()
    }
}
