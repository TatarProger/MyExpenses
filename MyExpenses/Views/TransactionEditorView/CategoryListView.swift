//
//  CategoryListView.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 12.07.2025.
//

import SwiftUI

struct CategoryListView: View {
    @Binding var selected: Category?
    let categories: [Category]

    var body: some View {
        List(categories) { category in
            Button {
                selected = category
            } label: {
                HStack {
                    Text(String(category.emoji))
                    Text(category.name)
                        .foregroundColor(.black)
                    if category.id == selected?.id {
                        Spacer()
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
        .navigationTitle("Выбор статьи")
    }
}
