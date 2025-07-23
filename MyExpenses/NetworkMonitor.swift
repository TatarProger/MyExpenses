//
//  NetworkMonitor.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 23.07.2025.
//

import Foundation
import Network

final class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")

    @Published var isConnected = true {
        didSet {
            if isConnected {
                Task {
                    await AppServices.shared.transactionsService.syncPendingTransactions()
                }
            }
        }
    }

    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
