//
//  TransactionEditorView.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 08.07.2025.
//

import SwiftUI

struct TransactionEditorView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: TransactionEditorViewModel

    private var isEditing: Bool {
        if case .edit = viewModel.mode { return true }
        return false
    }

    private var title: String {
        viewModel.direction == .income ? "Мои доходы" : "Мои расходы"
    }

    init(mode: TransactionEditorViewModel.Mode,
         transactionService: TransactionsServiceProtocol,
         accountService: BankAccountsServiceProtocol,
         categoriesService: CategoriesService,
         direction: Direction,
         onReload: (() async -> Void)? = nil) {

        let model = TransactionEditorViewModel(
            mode: mode,
            transactionService: transactionService,
            accountService: accountService,
            categoriesService: categoriesService,
            direction: direction
        )
        model.onReload = onReload
        _viewModel = StateObject(wrappedValue: model)
    }

    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: CategoryListView(
                    selected: $viewModel.selectedCategory,
                    categories: viewModel.availableCategories
                )) {
                    HStack {
                        Text("Статья")
                        Spacer()
                        if let selected = viewModel.selectedCategory {
                            Text("\(selected.emoji) \(selected.name)")
                        } else {
                            Text("Выбрать").foregroundColor(.gray)
                        }
                    }
                }

                HStack {
                    Text("Сумма")
                    TextField("Сумма", text: $viewModel.amount)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .onChange(of: viewModel.amount) {
                            viewModel.updateAmountInput(viewModel.amount)
                        }
                }

                HStack {
                    Text("Дата")
                    Spacer()
                    Text(viewModel.dateFormatted(viewModel.date))
                        .font(.body)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(.mintAccent)
                        .cornerRadius(8)
                        .overlay(
                            DatePicker(
                                "",
                                selection: $viewModel.date,
                                in: ...Date(),
                                displayedComponents: [.date]
                            )
                            .labelsHidden()
                            .blendMode(.destinationOver)
                        )
                }

                HStack {
                    Text("Время")
                    Spacer()
                    Text(viewModel.timeFormatted(viewModel.date))
                        .font(.body)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(.mintAccent)
                        .cornerRadius(8)
                        .overlay(
                            DatePicker(
                                "",
                                selection: $viewModel.date,
                                displayedComponents: [.hourAndMinute]
                            )
                            .labelsHidden()
                            .blendMode(.destinationOver)
                        )
                }


                TextField("Комментарий", text: $viewModel.comment)

                Section {
                    if isEditing {
                        Button("Удалить расход", role: .destructive) {
                            viewModel.deleteTransaction {
                                dismiss()
                            }
                        }
                    }
                }

            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(viewModel.mode == .create ? "Создать" : "Сохранить") {
                        if viewModel.isValid {
                            viewModel.handleSubmit {
                                dismiss()
                            }
                        } else {
                            viewModel.showAlert = true
                        }
                    }
                }
            }
            
        }
        .alert("Пожалуйста, заполните все поля", isPresented: $viewModel.showAlert) {
            Button("ОК", role: .cancel) { }
        }
    }
}

extension TransactionEditorViewModel.Mode: Equatable {
    static func == (lhs: TransactionEditorViewModel.Mode, rhs: TransactionEditorViewModel.Mode) -> Bool {
        switch (lhs, rhs) {
        case (.create, .create):
            return true
        case (.edit(let l), .edit(let r)):
            return l.id == r.id
        default:
            return false
        }
    }
}


extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}



