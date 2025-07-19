//
//  Untitled.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 18.06.2025.
//

import SwiftUI

//struct TransactionListView: View {
//    @StateObject private var viewModel: TransactionViewModel
//    @State private var showHistory = false
//    @State private var showSheet = false
//    
//    private var title: String {
//        viewModel.direction == .income ? "Доходы сегодня" : "Расходы сегодня"
//    }
//    
//    init(direction: Direction, accountId: Int) {
//        _viewModel = StateObject(wrappedValue: TransactionViewModel(
//            accountId: accountId,
//            direction: direction,
//            transactionService: AppServices.shared.transactionsService
//        ))
//
//    }
//    
//    var body: some View {
//        NavigationStack {
//            ZStack(alignment: .bottomTrailing) {
//                List {
//                    Section{
//                        HStack {
//                            Text("Всего")
//                            Spacer()
//                            Text("\(viewModel.total) ₽")
//                        }
//                    }
//                    
//                    Section(header: Text("операции")) {
//                        ForEach(viewModel.transactions) { transaction in
//                            NavigationLink {
//                                TransactionEditorView(
//                                    mode: .edit(transaction),
//                                    transactionService: AppServices.shared.transactionsService,
//                                    accountService: AppServices.shared.bankAccountsService,
//                                    categoriesService: AppServices.shared.categoriesService,
//                                    onReload: {
//                                        try? await viewModel.loadTransactions()
//                                    }
//                                )
//
//                                .navigationBarBackButtonHidden(true)
//                            } label: {
//                                TransactionCellView(transaction: transaction)
//                            }
//                        }
//                    }
//                }
//                .listStyle(.insetGrouped)
//                .navigationTitle(title)
//                .navigationDestination(isPresented: $showHistory) {
//                    MyHistoryView(
//                        viewModel: TransactionHistoryViewModel(
//                            accountId: viewModel.accountId,
//                            direction: viewModel.direction
//                        )
//                    )
//                }
//                .navigationDestination(isPresented: $showSheet, destination: {
//                    TransactionEditorView(
//                        mode: .create,
//                        transactionService: AppServices.shared.transactionsService,
//                        accountService: AppServices.shared.bankAccountsService,
//                        categoriesService: AppServices.shared.categoriesService
//                    )
//                        .navigationBarBackButtonHidden(true)
//                })
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button {
//                            showHistory = true
//                        } label: {
//                            Image(systemName: "clock")
//                                .foregroundColor(.purpleAccent)
//                        }
//                    }
//                }
//                
//                Button(action: {
//                    showSheet = true
//                }) {
//                    Image(systemName: "plus")
//                        .font(.system(size: 20, weight: .light))
//                        .foregroundColor(.white)
//                        .frame(width: 56, height: 56)
//                        .background(Color.green)
//                        .clipShape(Circle())
//                }
//                .padding(.trailing, 20)
//                .padding(.bottom, 20)
//            }
//
//        }
//        .onAppear {
//            Task {
//                try? await viewModel.loadTransactions()
//            }
//        }
//        .onChange(of: showSheet) { isShown in
//            if !isShown {
//                Task {
//                    try? await viewModel.loadTransactions()
//                }
//            }
//        }
//    }
//    
//}
//

struct TransactionListView: View {
    @StateObject private var viewModel: TransactionViewModel
    @State private var showHistory = false
    @State private var showSheet = false
    
    private var title: String {
        viewModel.direction == .income ? "Доходы сегодня" : "Расходы сегодня"
    }
    
    init(direction: Direction, accountId: Int) {
        _viewModel = StateObject(wrappedValue: TransactionViewModel(
            accountId: accountId,
            direction: direction,
            transactionService: AppServices.shared.transactionsService
        ))
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                transactionList
                addButton
            }
            .navigationTitle(title)
            .toolbar { historyButton }
            .navigationDestination(isPresented: $showHistory) {
                MyHistoryView(direction: viewModel.direction, accountId: viewModel.accountId)
            }
            .navigationDestination(isPresented: $showSheet) {
                TransactionEditorView(
                    mode: .create,
                    transactionService: AppServices.shared.transactionsService,
                    accountService: AppServices.shared.bankAccountsService,
                    categoriesService: AppServices.shared.categoriesService,
                    direction: viewModel.direction,
                    onReload: {
                        try? await viewModel.loadTransactions()
                    }
                )
                .navigationBarBackButtonHidden(true)
            }
            .onAppear {
                Task {
                    try? await viewModel.loadTransactions()
                }
            }
            .onChange(of: showSheet) { oldValue, newValue in
                if !newValue {
                    Task {
                        try? await viewModel.loadTransactions()
                    }
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ZStack {
                        //Color.black.opacity(0.3).ignoresSafeArea()
                        ProgressView("Загрузка...")
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                    }
                }
            }
            .alert("Ошибка", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("Ок", role: .cancel) {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }

        }
    }
}

private extension TransactionListView {
    var transactionList: some View {
        List {
            Section {
                HStack {
                    Text("Всего")
                    Spacer()
                    Text("\(viewModel.total) ₽")
                }
            }
            
            Section(header: Text("операции")) {
                ForEach(viewModel.transactions) { transaction in
                    NavigationLink {
                        TransactionEditorView(
                            mode: .edit(transaction),
                            transactionService: AppServices.shared.transactionsService,
                            accountService: AppServices.shared.bankAccountsService,
                            categoriesService: AppServices.shared.categoriesService,
                            direction: viewModel.direction,
                            onReload: {
                                try? await viewModel.loadTransactions()
                            }
                        )
                        .navigationBarBackButtonHidden(true)
                    } label: {
                        TransactionCellView(transaction: transaction)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
    
    var addButton: some View {
        Button(action: { showSheet = true }) {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .light))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(Color.green)
                .clipShape(Circle())
        }
        .padding(.trailing, 20)
        .padding(.bottom, 20)
    }
    
    var historyButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                showHistory = true
            } label: {
                Image(systemName: "clock")
                    .foregroundColor(.purpleAccent)
            }
        }
    }
}



