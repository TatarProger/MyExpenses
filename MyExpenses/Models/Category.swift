//
//  Category.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 08.06.2025.
//

import Foundation

struct Category: Codable {
    let id: Int
    let name: String
    let emoji: String //Character
    let isIncome: Bool //Свой enum
}
