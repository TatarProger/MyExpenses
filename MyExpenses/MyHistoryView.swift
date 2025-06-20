//
//  MyHistory.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 19.06.2025.
//

import SwiftUI


@MainActor
class TransactionHistoryViewModel: ObservableObject {
    enum SortType: String, CaseIterable, Identifiable {
        case byDate = "По дате"
        case byAmount = "По сумме"
        
        var id: String { self.rawValue }
    }

    let accountId: Int
    let direction: Direction
    private let service = TransactionsService()

    @Published var transactions: [Transaction] = []
//    @Published var startDate: Date
//    @Published var endDate: Date
    @Published var startDate: Date {
        didSet {
            if startDate > endDate {
                endDate = startDate
            }
            Task { await loadTransactions() }
        }
    }

    @Published var endDate: Date {
        didSet {
            if endDate < startDate {
                startDate = endDate
            }
            Task { await loadTransactions() }
        }
    }
    @Published var total: Decimal = 0
    @Published var sortType: SortType = .byDate

    private let calendar = Calendar.current

    init(accountId: Int, direction: Direction) {
        self.accountId = accountId
        self.direction = direction

        let now = Date()
        let end = calendar.startOfDay(for: now)
        self.endDate = end
        self.startDate = calendar.date(byAdding: .month, value: -1, to: end) ?? end
    }

    func loadTransactions() async {
        let startDateTime = calendar.startOfDay(for: startDate)
        let endDateTime = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endDate) ?? endDate

        do {
            let all = try await service.fetchTransactionsForPeriod(accountId, startDateTime, endDateTime)
            let filtered = all.filter { $0.category.income == direction }

            let sorted: [Transaction]
            switch sortType {
            case .byDate:
                sorted = filtered.sorted { ($0.transactionDate ?? .distantPast) > ($1.transactionDate ?? .distantPast) }
            case .byAmount:
                sorted = filtered.sorted { $0.amount > $1.amount }
            }

            transactions = sorted
            total = sorted.map { $0.amount }.reduce(0, +)
        } catch {
            print("Ошибка загрузки транзакций: \(error)")
        }
    }
}




struct MyHistoryView: View {
    @ObservedObject var viewModel: TransactionHistoryViewModel
    
    @State private var isSortSheetPresented = false
    @State private var selectedSortOption: SortOption = .byDate

    enum SortOption: String, CaseIterable {
        case byDate = "По дате"
        case byAmount = "По сумме"
    }


    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Моя история")
                .font(.largeTitle)
                .bold()

            VStack(alignment: .leading) {
                HStack {
                    Text("Начало")
                    Spacer()

                    Text(dateFormatted(viewModel.startDate))
                        .font(.body)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(Color(red: 212/255, green: 250/255, blue: 230/255))
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

                Divider()

                HStack {
                    Text("Конец")
                    Spacer()

                    Text(dateFormatted(viewModel.endDate))
                        .font(.body)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(Color(red: 212/255, green: 250/255, blue: 230/255))
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

                Divider()
                
                Picker("Сортировка", selection: $viewModel.sortType) {
                    ForEach(TransactionHistoryViewModel.SortType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: viewModel.sortType) { _, _ in
                    Task { await viewModel.loadTransactions() }
                }

                Divider()

                HStack {
                    Text("Сумма")
                    Spacer()
                    Text("\(viewModel.total) ₽")
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)

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
                .frame(maxHeight: CGFloat(viewModel.transactions.count * 57))

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
                .frame(maxHeight: CGFloat(viewModel.transactions.count * 57))


            }
                
                

            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemGray6).ignoresSafeArea())
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

    private func dateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter.string(from: date)
    }

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

//    private func outcomeCell(_ transaction: Transaction) -> some View {
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
    
    private func incomeCell(_ transaction: Transaction) -> some View {
        HStack(alignment: .top, spacing: 12) {

            // Название и комментарий
            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.category.name)
                    .font(.system(size: 16))
                    .foregroundColor(.primary)

                if let comment = transaction.comment, !comment.isEmpty {
                    Text(comment)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }

            Spacer()

            // Сумма, время и стрелка
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(transaction.amount) ₽")
                    .font(.system(size: 16))

                if let date = transaction.transactionDate {
                    Text(timeFormatted(date))
                        .font(.system(size: 16))
                }
            }

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .padding(.leading, 4)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(12)
    }

    
    private func outcomeCell(_ transaction: Transaction) -> some View {
        HStack(alignment: .top, spacing: 12) {
            // Иконка
            Text(transaction.category.emoji.description)
                .font(.system(size: 12))
                .frame(width: 28, height: 28, alignment: .center)
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
                        .lineLimit(1)
                }
            }

            Spacer()

            // Сумма, время и стрелка
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(transaction.amount) ₽")
                    .font(.system(size: 16))

                if let date = transaction.transactionDate {
                    Text(timeFormatted(date))
                        .font(.system(size: 16))
                }
            }

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .padding(.leading, 4)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(12)
    }

    
    private func timeFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }


}
