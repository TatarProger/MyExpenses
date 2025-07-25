//
//  MyExpensesApp.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 06.06.2025.
//

import SwiftUI

@main
struct MyExpensesApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        appearance.shadowColor = UIColor.lightGray 

        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }

}
