//
//  MyHistory.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 19.06.2025.
//

import SwiftUI

struct MyHistoryView: View {
    @StateObject var viewModel: TransactionHistoryViewModel
    
    @State private var isSortSheetPresented = false
    @State private var selectedSortOption: SortOption = .byDate
    @State private var showAnalize = false

    enum SortOption: String, CaseIterable {
        case byDate = "По дате"
        case byAmount = "По сумме"
    }

    init(direction: Direction, accountId: Int) {
        _viewModel = StateObject(wrappedValue: TransactionHistoryViewModel(
            accountId: accountId,
            direction: direction,
            transactionService: AppServices.shared.transactionsService
        ))
    }

    var body: some View {
        NavigationStack {
            List {
                datePickersSection
                sortPickerSection
                totalSection
                transactionsSection
            }
            .navigationTitle("Моя история")
            .navigationDestination(isPresented: $showAnalize) {
                MyHistoryViewControllerWrapper(direction: viewModel.direction, accountId: 1)
                    .ignoresSafeArea()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAnalize = true
                    } label: {
                        Image(systemName: "doc")
                            .foregroundColor(.purpleAccent)
                    }
                }
            }
        }
        .task { await viewModel.loadTransactions() }
        .onChange(of: viewModel.startDate) { _, _ in
            Task { await viewModel.loadTransactions() }
        }
        .onChange(of: viewModel.endDate) { _, _ in
            Task { await viewModel.loadTransactions() }
        }
    }
}

private extension MyHistoryView {
    var datePickersSection: some View {
        Group {
            HStack {
                Text("Начало")
                Spacer()
                datePickerLabel(for: $viewModel.startDate)
            }
            HStack {
                Text("Конец")
                Spacer()
                datePickerLabel(for: $viewModel.endDate)
            }
        }
    }

    func datePickerLabel(for binding: Binding<Date>) -> some View {
        Text(viewModel.dateFormatted(binding.wrappedValue))
            .font(.body)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(.mintAccent)
            .cornerRadius(8)
            .overlay(
                DatePicker("", selection: binding, displayedComponents: [.date])
                    .labelsHidden()
                    .blendMode(.destinationOver)
            )
    }

    var sortPickerSection: some View {
        Picker("Сортировка", selection: $viewModel.sortType) {
            ForEach(TransactionHistoryViewModel.SortType.allCases) { type in
                Text(type.rawValue).tag(type)
            }
        }
        .pickerStyle(.segmented)
        .onChange(of: viewModel.sortType) { _, _ in
            Task { await viewModel.loadTransactions() }
        }
    }

    var totalSection: some View {
        HStack {
            Text("Сумма")
            Spacer()
            Text("\(viewModel.total) ₽")
        }
    }

    var transactionsSection: some View {
        Section("операции") {
            ForEach(viewModel.transactions) { transaction in
                NavigationLink {
                    TransactionEditorView(
                        mode: .edit(transaction),
                        transactionService: AppServices.shared.transactionsService,
                        accountService: AppServices.shared.bankAccountsService,
                        categoriesService: AppServices.shared.categoriesService,
                        direction: viewModel.direction,
                        onReload: { await viewModel.loadTransactions() }
                    )
                    .navigationBarBackButtonHidden(true)
                } label: {
                    TransactionCellView(transaction: transaction)
                }
            }
        }
    }
}


    




