//
//  GraphicsView.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 24.07.2025.
//

import SwiftUI
import Charts

struct DailyBalance: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let balance: Double
}


struct BarChartView: View {
    let originalBalances: [DailyBalance]
    @State private var selectedBalance: DailyBalance? = nil
    @State private var dragLocation: CGPoint = .zero

    private var paddedBalances: [DailyBalance] {
        guard let last = originalBalances.last else { return originalBalances }
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: last.date)!
        let padding = DailyBalance(date: nextDay, balance: 0)
        return originalBalances + [padding]
    }

    var body: some View {
        ZStack {
            Chart(paddedBalances) { item in
                if item != paddedBalances.last {
                    BarMark(
                        x: .value("Дата", item.date),
                        y: .value("Баланс", abs(item.balance))
                    )
                    .cornerRadius(10)
                    .foregroundStyle(item.balance >= 0 ? .greenAccent : .orangeSet)
                }
            }
            .chartXAxis {
                AxisMarks(values: originalBalances.enumerated().compactMap { index, item in
                    [0, 14, 27].contains(index) ? item.date : nil
                }) { value in
                    if let date = value.as(Date.self) {
                        AxisValueLabel {
                            Text(date, format: .dateTime.day().month(.twoDigits))
                        }
                    }
                }
            }
            .chartYAxis(.hidden)
            .frame(height: 200)
            .padding()
            .chartOverlay { proxy in
                GeometryReader { geo in
                    Rectangle()
                        .fill(Color.clear)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    dragLocation = value.location
                                    if let date: Date = proxy.value(atX: value.location.x) {
                                        if let match = originalBalances.min(by: {
                                            abs($0.date.timeIntervalSince1970 - date.timeIntervalSince1970) <
                                            abs($1.date.timeIntervalSince1970 - date.timeIntervalSince1970)
                                        }) {
                                            selectedBalance = match
                                        }
                                    }
                                }
                                .onEnded { _ in
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        selectedBalance = nil
                                    }
                                }
                        )
                }
            }

            if let selected = selectedBalance {
                VStack {
                    Text("\(selected.balance, specifier: "%.2f")")
                        .font(.caption)
                        .padding(6)
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(6)
                        .position(x: dragLocation.x, y: dragLocation.y - 30)
                }
                .animation(.easeInOut, value: selectedBalance)
            }
        }
    }
}
