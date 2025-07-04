//
//  Untitled.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 18.06.2025.
//

import SwiftUI

struct TransactionListView: View {
    @StateObject private var viewModel: TransactionViewModel
    @State private var showHistory = false
    
    private var title: String {
        viewModel.direction == .income ? "Доходы сегодня" : "Расходы сегодня"
    }
    
    init(direction: Direction, accountId: Int) {
        _viewModel = StateObject(wrappedValue: TransactionViewModel(accountId: accountId, direction: direction))
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                List {
                    Section{
                        HStack {
                            Text("Всего")
                            Spacer()
                            Text("\(viewModel.total) ₽")
                        }
                    }
                    
                    Section(header: Text("операции")) {
                        ForEach(viewModel.transactions) { transaction in
                            TransactionCellView(transaction: transaction)
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .navigationTitle(title)
                .navigationDestination(isPresented: $showHistory) {
                    MyHistoryView(
                        viewModel: TransactionHistoryViewModel(
                            accountId: viewModel.accountId,
                            direction: viewModel.direction
                        )
                    )
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showHistory = true
                        } label: {
                            Image(systemName: "clock")
                                .foregroundColor(.purpleAccent)
                        }
                    }
                }
                
                Button(action: {
                }) {
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

        }
        .onAppear {
            Task {
                try? await viewModel.loadTransactions()
            }
        }
    }
    
}


