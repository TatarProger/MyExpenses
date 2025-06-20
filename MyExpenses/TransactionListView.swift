//
//  Untitled.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 18.06.2025.
//

import SwiftUI

class TransactionViewModel: ObservableObject {
    let accountId: Int
    let direction: Direction
    @Published var total: Decimal = 0
    @Published var transactions:[Transaction] = []
    private let service = TransactionsService()
    
    init(accountId: Int, direction: Direction) {
        self.accountId = accountId
        self.direction = direction
    }
    
    func loadTransactions() async throws {
        let calendar = Calendar.current
        let now = Date()
        let stratOfDay = calendar.startOfDay(for: now)
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: now) ?? Date()
        let transactionsList = try await service.fetchTransactionsForPeriod(accountId, stratOfDay, endOfDay).filter {$0.category.income == direction}
        await MainActor.run {
            transactions = transactionsList
            total = transactionsList.map { $0.amount }.reduce(0, +)
        }
    }
    
}

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
//                    List(viewModel.transactions) { transaction in
//                        outcomeCell(transaction)
//                    }
//                    .listStyle(.plain)
//                    .cornerRadius(16)
//                    .background(Color(UIColor.systemGray6).ignoresSafeArea())
//                    .padding(.horizontal, 5)
                    
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
                        Image(systemName: "clock") // Замени при необходимости
                    }
                }
            }
            .onAppear {
                Task {
                    try? await viewModel.loadTransactions()
                }
            }
        }
    }

    // MARK: - Ячейка для доходов
//    private func incomeCell(_ transaction: Transaction) -> some View {
//        HStack {
//            Text(transaction.category.emoji.description)
//                .font(.system(size: 12))
//                .frame(width: 23, height: 23)
//                .background(Color.green)
//                .cornerRadius(18)
//
//            Text(transaction.category.name)
//                .lineLimit(1)
//
//            Spacer()
//
//            Text("\(transaction.amount) ₽")
//            Image(systemName: "chevron.right")
//                .foregroundColor(.gray)
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(12)
//        .listRowInsets(EdgeInsets())
//    }

    // MARK: - Ячейка для расходов
//    private func outcomeCell(_ transaction: Transaction) -> some View {
//        HStack {
//            Text(transaction.category.emoji.description)
//                .font(.system(size: 12))
//                .frame(width: 23, height: 23)
//                .background(Color(red: 212 / 255, green: 250 / 255, blue: 230 / 255))
//                .cornerRadius(20)
//            
//            
////            Text(transaction.category.name)
////                .lineLimit(1)
//            if transaction.comment == nil {
//                Text(transaction.category.name)
//                    .lineLimit(1)
//            }
//            if transaction.comment != nil {
//                (Text("\(transaction.category.name)\n")
//                    .font(.system(size: 17))
//                + Text(transaction.comment ?? "")
//                    .font(.system(size: 13))
//                    .foregroundColor(.gray))
//                .lineLimit(2)
//                .multilineTextAlignment(.leading)
//            }
//
//            Spacer()
//
//            Text("\(transaction.amount) ₽")
//            Image(systemName: "chevron.right")
//                .foregroundColor(.gray)
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(12)
//        .listRowInsets(EdgeInsets())
//    }
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
        .padding(.horizontal, 18) // ← Вернул боковые отступы
        .background(Color.white)
    }

    private func incomeCell(_ transaction: Transaction) -> some View {
        HStack(alignment: .center, spacing: 12) {
            // Иконка
//            Text(transaction.category.emoji.description)
//                .font(.system(size: 12))
//                .frame(width: 23, height: 23)
//                .background(Color(red: 212/255, green: 250/255, blue: 230/255))
//                .cornerRadius(18)

            Text(transaction.category.name)
                .font(.system(size: 16))
                .foregroundColor(.primary)
            
            // Название и комментарий
//            VStack(alignment: .leading, spacing: 2) {
//                Text(transaction.category.name)
//                    .font(.system(size: 16))
//                    .foregroundColor(.primary)
//
//                if let comment = transaction.comment, !comment.isEmpty {
//                    Text(comment)
//                        .font(.system(size: 13))
//                        .foregroundColor(.gray)
//                }
//            }

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
        .padding(.horizontal, 18) // ← Вернул боковые отступы
        .background(Color.white)
    }
}
