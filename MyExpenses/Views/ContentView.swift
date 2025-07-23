//
//  ContentView.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 06.06.2025.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var monitor = NetworkMonitor()
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            VStack (spacing: 3) {
                
                if !monitor.isConnected {
                    NetworkBanner()
                        .zIndex(1)
                }
                
                TabView {
                    TransactionListView(direction: .outcome, accountId: 92)
                        .tabItem() {
                            Image("Outcomes")
                                .renderingMode(.template)
                            Text("Расходы")
                        }
                    TransactionListView(direction: .income, accountId: 92)
                        .tabItem() {
                            Image("Incomes")
                                .renderingMode(.template)
                            Text("Доходы")
                        }
                    MyBalanceView()
                        .tabItem() {
                            Image("Account1")
                                .renderingMode(.template)
                            Text("Счет")
                        }
                    MyCategoriesView()
                        .tabItem() {
                            Image("Items1")
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
        //.ignoresSafeArea(edges: .top)
        .animation(.easeInOut, value: monitor.isConnected)
    }
    

}

#Preview {
    ContentView()
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: Double
        r = Double((int >> 16) & 0xFF) / 255
        g = Double((int >> 8) & 0xFF) / 255
        b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
