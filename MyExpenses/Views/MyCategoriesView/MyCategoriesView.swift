//
//  MyItems.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 01.07.2025.
//

import SwiftUI

struct MyCategoriesView: View {
    @StateObject private var viewModel = MyCategoriesViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    SearchBarView(text: $viewModel.searchText)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    List {
                        Section(header: Text("Операции")) {
                            ForEach(viewModel.filteredTransactions) { transaction in
                                CategoryCellView(transaction: transaction)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .background(Color.white)
                }
            }
            .navigationTitle("Мои статьи")
        }
        .onAppear {
            Task {
                await viewModel.loadTransactions()
            }
        }
    }

}



