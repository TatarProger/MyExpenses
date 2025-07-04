//
//  SearchBarView.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 04.07.2025.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Поиск", text: $text)
                .textInputAutocapitalization(.never)
            Spacer()
            Image(systemName: "mic.fill")
                .foregroundColor(.gray)
        }
        .padding(10)
        .background(Color(.systemGray5))
        .foregroundColor(Color(.systemGray))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top, -10)
    }
}
