//
//  MyHistory.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 19.06.2025.
//

import SwiftUI

struct MyHistoryView: View {
    @ObservedObject var viewModel: TransactionHistoryViewModel
    
    @State private var isSortSheetPresented = false
    @State private var selectedSortOption: SortOption = .byDate

    enum SortOption: String, CaseIterable {
        case byDate = "По дате"
        case byAmount = "По сумме"
    }
    
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    Text("Начало")
                    Spacer()
                    
                    Text(viewModel.dateFormatted(viewModel.startDate))
                        .font(.body)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(.mintAccent)
                        .cornerRadius(8)
                        .overlay(
                            DatePicker(
                                "",
                                selection: $viewModel.startDate,
                                displayedComponents: [.date]
                            )
                            .labelsHidden()
                            .blendMode(.destinationOver)
                        )
                }
                
                HStack {
                    Text("Конец")
                    Spacer()
                    
                    Text(viewModel.dateFormatted(viewModel.endDate))
                        .font(.body)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(.mintAccent)
                        .cornerRadius(8)
                        .overlay(
                            DatePicker(
                                "",
                                selection: $viewModel.endDate,
                                displayedComponents: [.date]
                            )
                            .labelsHidden()
                            .blendMode(.destinationOver)
                        )
                }
                
                Picker("Сортировка", selection: $viewModel.sortType) {
                    ForEach(TransactionHistoryViewModel.SortType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: viewModel.sortType) { _, _ in
                    Task { await viewModel.loadTransactions() }
                }
                
                
                HStack {
                    Text("Сумма")
                    Spacer()
                    Text("\(viewModel.total) ₽")
                }
                
                Section("операции") {
                    ForEach(viewModel.transactions) { transaction in
                        TransactionCellView(transaction: transaction)
                    }
                }
                
            }
            .navigationTitle("Моя история")
        }
        .task {
            await viewModel.loadTransactions()
        }
        .onChange(of: viewModel.startDate) { _, _ in
            Task { await viewModel.loadTransactions() }
        }
        .onChange(of: viewModel.endDate) { _, _ in
            Task { await viewModel.loadTransactions() }
        }
    }
    
}


    




