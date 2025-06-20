//
//  ContentView.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 06.06.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TransactionListView(direction: .outcome, accountId: 1)
                .tabItem() {
                    Image("Outcomes")
                        .renderingMode(.template)
                    Text("Расходы")
                }
            TransactionListView(direction: .income, accountId: 1)
                .tabItem() {
                    Image("Incomes")
                        .renderingMode(.template)
                    Text("Доходы")
                }
            Text("Счет")
                .tabItem() {
                    Image("Account")
                        .renderingMode(.template)
                    Text("Счет")
                }
            Text("Статьи")
                .tabItem() {
                    Image("Items")
                        .renderingMode(.template)
                    Text("Статьи")
                }
            Text("Настройки")
                .tabItem() {
                    Image("Settings")
                        .renderingMode(.template)
                    Text("Настройки")
                }
        }.accentColor(Color(red: 42/255, green: 232/255, blue: 129/255))

    }
    

}

#Preview {
    ContentView()
}
