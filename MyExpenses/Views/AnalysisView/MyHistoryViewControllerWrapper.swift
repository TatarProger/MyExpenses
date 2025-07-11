//
//  MyHistoryViewControllerWrapper.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 11.07.2025.
//

import SwiftUI

struct MyHistoryViewControllerWrapper: UIViewControllerRepresentable {
    let direction: Direction
    let accountId: Int

    func makeUIViewController(context: Context) -> AnalysisViewController {
        let controller = AnalysisViewController(direction: direction, accountId: accountId)
        return controller
    }

    func updateUIViewController(_ uiViewController: AnalysisViewController, context: Context) {

    }
}
