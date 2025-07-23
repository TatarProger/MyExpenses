//
//  CategoriesEntity.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 23.07.2025.
//

import Foundation
import SwiftData

@Model
final class CategoryEntity {
    @Attribute(.unique) var id: Int
    var name: String
    var emoji: String
    private var incomeRawValue: String

    var income: Direction {
        get { Direction(rawValue: incomeRawValue) ?? .outcome }
        set { incomeRawValue = newValue.rawValue }
    }

    init(id: Int, name: String, emoji: String, income: Direction) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.incomeRawValue = income.rawValue
    }
}


