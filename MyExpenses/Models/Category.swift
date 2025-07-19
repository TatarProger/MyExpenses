//
//  Category.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 08.06.2025.
//

import Foundation
//
enum Direction: String, Codable, Equatable {
    case income
    case outcome
}

struct Category: Decodable, Equatable, Identifiable {
    let id: Int
    let name: String
    let emoji: Character
    let income: Direction

    enum CodingKeys: String, CodingKey {
        case id, name, emoji, isIncome
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)

        let emojiString = try container.decode(String.self, forKey: .emoji)
        emoji = emojiString.first ?? "?"

        let isIncome = try container.decode(Bool.self, forKey: .isIncome)
        income = isIncome ? .income : .outcome

        print("✅ Category decoded: id=\(id), name=\(name), income=\(income)")
    }
}
