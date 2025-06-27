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
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.system(size: 34, weight: .bold))
                    
                    HStack {
                        Text("Всего")
                        Spacer()
                        Text("\(viewModel.total) ₽")
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    
                    Text("ОПЕРАЦИИ")
                        .font(.system(size: 17))
                        .foregroundColor(Color.gray)
                        .padding(.leading, 16)
                        .padding(.top, 16)
                    
                    
                    switch viewModel.direction {
                    case .income:
                        List(viewModel.transactions) { transaction in
                            incomeCell(transaction)
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(Color.clear)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .listStyle(.plain)
                        .padding(.horizontal, 5)
                        .frame(maxHeight: CGFloat(viewModel.transactions.count * 44))
                        
                    case .outcome:
                        
                        List(viewModel.transactions) { transaction in
                            outcomeCell(transaction)
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(Color.clear)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .listStyle(.plain)
                        //.padding(.horizontal, 5)
                        .frame(maxHeight: CGFloat(viewModel.transactions.count * 49))
                        
                        
                    }
                    
                    
                    
                    Spacer()
                }
                .padding()
                .background(Color(UIColor.systemGray6).ignoresSafeArea())
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
                                .foregroundColor(Color(red: 111/255, green: 93/255, blue: 183/255))
                        }
                    }
                }
                .onAppear {
                    Task {
                        try? await viewModel.loadTransactions()
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
    }

    

    private func outcomeCell(_ transaction: Transaction) -> some View {
        HStack(alignment: .center, spacing: 12) {
            // Иконка
            Text(transaction.category.emoji.description)
                .font(.system(size: 12))
                .frame(width: 23, height: 23)
                .background(Color(red: 212/255, green: 250/255, blue: 230/255))
                .cornerRadius(18)
            
            // Название и комментарий
            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.category.name)
                    .font(.system(size: 16))
                    .foregroundColor(.primary)
                
                if let comment = transaction.comment, !comment.isEmpty {
                    Text(comment)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // Сумма и стрелка
            HStack(spacing: 4) {
                Text("\(transaction.amount) ₽")
                    .font(.system(size: 16))
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 18)
        .background(Color.white)
    }
    
    private func incomeCell(_ transaction: Transaction) -> some View {
        HStack(alignment: .center, spacing: 12) {
            
            Text(transaction.category.name)
                .font(.system(size: 16))
                .foregroundColor(.primary)
            
            Spacer()
            
            HStack(spacing: 4) {
                Text("\(transaction.amount) ₽")
                    .font(.system(size: 16))
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 18)
        .background(Color.white)
    }
}
