//
//  StatItem.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 08.06.2025.
//

import Foundation

struct StatItem: Codable {
    let categoryId: Int
    let categoeyName: String
    let emoji: String //Character
    let amount: String
}
