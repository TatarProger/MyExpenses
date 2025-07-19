//
//  MyItems.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 01.07.2025.
//

import SwiftUI

//struct MyCategoriesView: View {
//    @StateObject private var viewModel = MyCategoriesViewModel(accountId: 0, service: TransactionsService(networkClient: NetworkClient(baseURL: URL(string: "https://shmr-finance.ru/api/v1")!, bearerToken: "jXK6tFet5YGBbfYliKp2raJX")))
//
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                Color(.systemGroupedBackground)
//                    .ignoresSafeArea()
//
//                VStack(spacing: 0) {
//                    SearchBarView(text: $viewModel.searchText)
//                        .padding(.horizontal)
//                        .padding(.top, 8)
//                    
//                    List {
//                        Section(header: Text("Операции")) {
//                            ForEach(viewModel.filteredTransactions) { transaction in
//                                CategoryCellView(transaction: transaction)
//                            }
//                        }
//                    }
//                    .listStyle(.insetGrouped)
//                    .background(Color.white)
//                }
//            }
//            .navigationTitle("Мои статьи")
//        }
//        .onAppear {
//            Task {
//                await viewModel.loadTransactions()
//            }
//        }
//    }
//
//}



struct MyCategoriesView: View {
    @StateObject private var viewModel = MyCategoriesViewModel(service: AppServices.shared.categoriesService)

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
                        Section(header: Text("Категории")) {
                            ForEach(viewModel.filteredCategories) { category in
                                HStack {
                                    Text(String(category.emoji))
                                    Text(category.name)
                                    Spacer()
                                    Text(category.income.rawValue.capitalized)
                                        .foregroundColor(category.income == .income ? .green : .red)
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .background(Color.white)
                }
            }
            .navigationTitle("Мои статьи")
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
        .onAppear {
            Task {
                await viewModel.loadCategories()
            }
        }
    }
}
