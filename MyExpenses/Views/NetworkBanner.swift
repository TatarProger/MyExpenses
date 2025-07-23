//
//  NetworkBanner.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 23.07.2025.
//

import SwiftUI

struct NetworkBanner: View {
    var body: some View {
        Text("Нет подключения к интернету")
            .frame(height: 20)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .transition(.move(edge: .top).combined(with: .opacity))
    }
}
