//
//  RootView.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 25.07.2025.
//

import SwiftUI
import LottieViewSpmModule

struct RootView: View {
    @State private var showSplash = true
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashView(isActive: $showSplash)
            } else {
                ContentView()  // <-- твой код
            }
        }
    }
}
