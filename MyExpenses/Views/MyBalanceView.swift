//
//  MyBalanceView.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 24.06.2025.
//
import SwiftUI

struct MyBalanceView: View {
    @State private var shakeCoordinator: ShakeDetector.Coordinator?


    func currencyDisplayName(_ code: String) -> String {
        switch code {
        case "RUB": return "Российский рубль ₽"
        case "USD": return "Американский доллар $"
        case "EUR": return "Евро €"
        default: return code
        }
    }

    @StateObject var viewModel = BankAccountViewModel(
        service: AppServices.shared.bankAccountsService
    )
    @State private var isEditing = false
    @State private var showCurrencySheet = false
    @FocusState private var isBalanceFocused: Bool

    let availableCurrencies = ["RUB", "USD", "EUR"]

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 16) {
                        if let account = viewModel.account {
                            // Баланс
                            HStack {
                                Text("💰 Баланс")
                                Spacer()

                                if isEditing {
                                        TextField("Баланс", text: $viewModel.editedBalance)
                                            .keyboardType(.decimalPad)
                                            .multilineTextAlignment(.trailing)
                                            .focused($isBalanceFocused)
                                            .toolbar {
                                                ToolbarItemGroup(placement: .keyboard) {
                                                    Spacer()
                                                    Button("Вставить") {
                                                        if let text = UIPasteboard.general.string {
                                                            let filtered = text.filter { "0123456789.,".contains($0) }
                                                                .replacingOccurrences(of: ",", with: ".")
                                                            viewModel.editedBalance = filtered
                                                        }
                                                    }
                                                }
                                            }
                                    
                                } else {
                                    ZStack {
                                        Text("\(viewModel.account?.balance.description ?? "") \(viewModel.account?.currency ?? "")")
                                            .foregroundColor(.black)
                                            .opacity(viewModel.isBalanceHidden ? 0 : 1)

                                        if viewModel.isBalanceHidden {
                                            
                                            SpoilerView(isOn: true)
                                                .frame(height: 20)
                                                .cornerRadius(4)
                                                .transition(.opacity)
                                        }
                                    }
                                }

                            }
                            .padding()
                            .background(.greenAccent)
                            .cornerRadius(10)

                            Button {
                                if isEditing {
                                    showCurrencySheet = true
                                }
                            } label: {
                                HStack {
                                    Text("Валюта")
                                    Spacer()
                                    Text(isEditing ? viewModel.editedCurrency : account.currency)
                                        .foregroundColor(.black)
                                    if isEditing {
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(.greenAccent)
                                    }
                                }
                                .padding()
                                .background(.mintAccent)
                                .cornerRadius(10)
                            }
                            .buttonStyle(.plain)
                        } else {
                            ProgressView()
                        }

                        Spacer()
                    }
                    .padding()
                }
                
                ShakeDetector(onShake: {
                    withAnimation(.easeInOut) {
                        viewModel.isBalanceHidden.toggle()
                    }
                }, coordinatorRef: $shakeCoordinator)
                .frame(width: 0, height: 0)

            }
            
            .onAppear {
                Task {
                    await viewModel.fetchAccount()
                }
            }
            .refreshable {
                Task {
                    await viewModel.fetchAccount()
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
            .navigationTitle("Мой счёт")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Сохранить" : "Редактировать") {
                        if isEditing {
                            Task {
                                await viewModel.saveChanges()
                                viewModel.isBalanceHidden = false
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    shakeCoordinator?.activate()
                                }
                                
                                
                            }
                        } else {
                            viewModel.enterEditMode()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                shakeCoordinator?.deactivate()
                            }
                        }
                        isEditing.toggle()
                        isBalanceFocused = false
                    }
                    .foregroundColor(.purpleAccent)
                }
            }
            .sheet(isPresented: $showCurrencySheet) {
                VStack(spacing: 0) {
                    Text("Валюта")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(.vertical, 16)

                    Divider()

                    ForEach(availableCurrencies, id: \.self) { currency in
                        Button(action: {
                            if viewModel.editedCurrency != currency {
                                viewModel.editedCurrency = currency
                            }
                            showCurrencySheet = false
                        }) {
                            Text(currencyDisplayName(currency))
                                .font(.system(size: 17))
                                .foregroundColor(.green)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                        }

                        if currency != availableCurrencies.last {
                            Divider()
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(16)
                .padding(.horizontal, 16)
                .presentationDetents([.height(300)])
                .interactiveDismissDisabled(false)
                .presentationBackground(.clear)
            }
        }
    }
}

struct ShakeDetector: UIViewRepresentable {
    var onShake: () -> Void
    @Binding var coordinatorRef: Coordinator?

    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        DispatchQueue.main.async {
            self.coordinatorRef = coordinator
        }
        return coordinator
    }

    func makeUIView(context: Context) -> ShakeUIView {
        let view = ShakeUIView()
        view.onShake = onShake
        context.coordinator.view = view
        return view
    }

    func updateUIView(_ uiView: ShakeUIView, context: Context) {

    }

    class Coordinator {
        weak var view: ShakeUIView?

        func activate() {
            view?.becomeFirstResponder()
        }
        
        func deactivate() {
            view?.resignFirstResponder()
        }
    }
}



class ShakeUIView: UIView {
    var onShake: (() -> Void)?

    override var canBecomeFirstResponder: Bool { true }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        becomeFirstResponder()
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        if motion == .motionShake {
            onShake?()
        }
    }
}


