//
//  AnalizeView.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 08.07.2025.
//

import SwiftUI
import UIKit
import PieChart

//class AnalysisViewController: UIViewController {
//    private let viewModel: TransactionAnalizeViewModel
//    private let infoTableView = UITableView(frame: .zero, style: .insetGrouped)
//    private let operationsTableView = UITableView(frame: .zero, style: .insetGrouped)
//
//    private let spinner = UIActivityIndicatorView(style: .large)
//    private let dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "d MMMM yyyy"
//        formatter.locale = Locale(identifier: "ru_RU")
//        return formatter
//    }()
//
//    init(direction: Direction, accountId: Int) {
//        self.viewModel = TransactionAnalizeViewModel(
//            accountId: accountId,
//            direction: direction,
//        )
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        setupSpinner()
//        loadTransactions()
//        
//        viewModel.triggerReload = { [weak self] in
//            DispatchQueue.main.async {
//                self?.infoTableView.reloadData()
//                self?.operationsTableView.reloadData()
//            }
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
//                self?.infoTableView.reloadData()
//                self?.operationsTableView.reloadData()
//            }
//        }
//
//
//    }
//
//    private func setupUI() {
//        view.backgroundColor = .systemGroupedBackground
//
//        infoTableView.dataSource = self
//        infoTableView.delegate = self
//        infoTableView.isScrollEnabled = false
//        infoTableView.register(PeriodInfoTableViewCell.self, forCellReuseIdentifier: PeriodInfoTableViewCell.identifier)
//
//        operationsTableView.dataSource = self
//        operationsTableView.delegate = self
//        operationsTableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionTableViewCell.identifier)
//
//        infoTableView.translatesAutoresizingMaskIntoConstraints = false
//        operationsTableView.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(infoTableView)
//        view.addSubview(operationsTableView)
//
//        NSLayoutConstraint.activate([
//            infoTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -50),
//            infoTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            infoTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            infoTableView.heightAnchor.constraint(equalToConstant: 250),
//
//            operationsTableView.topAnchor.constraint(equalTo: infoTableView.bottomAnchor),
//            operationsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            operationsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            operationsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//    
//    private func setupSpinner() {
//        spinner.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(spinner)
//        NSLayoutConstraint.activate([
//            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
//    
//    
//    private func openEditor(for transaction: Transaction) {
//        let editorView = TransactionEditorView(
//            mode: .edit(transaction),
//            transactionService: AppServices.shared.transactionsService,
//            accountService: AppServices.shared.bankAccountsService,
//            categoriesService: AppServices.shared.categoriesService,
//            direction: transaction.category.income
//        ) {
//            Task { await self.loadTransactions() }
//        }
//
//        let hostingController = UIHostingController(rootView: editorView)
//        present(hostingController, animated: true)
//    }
//
//
////    private func loadTransactions() {
////        Task {
////            await viewModel.loadTransactions()
////            DispatchQueue.main.async {
////                self.infoTableView.reloadData()
////                self.operationsTableView.reloadData()
////            }
////        }
////    }
//    
//    private func loadTransactions() {
//        spinner.startAnimating()
//        Task {
//            do {
//                try await viewModel.loadTransactions()
//                DispatchQueue.main.async {
//                    self.infoTableView.reloadData()
//                    self.operationsTableView.reloadData()
//                    self.spinner.stopAnimating()
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    self.spinner.stopAnimating()
//                    self.showErrorAlert(message: error.localizedDescription)
//                }
//            }
//        }
//    }
//    
//    private func showErrorAlert(message: String) {
//        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ок", style: .default))
//        present(alert, animated: true)
//    }
//}
//
//
////MARK: UITableViewDataSource, UITableViewDelegate
//extension AnalysisViewController: UITableViewDataSource, UITableViewDelegate {
//    func numberOfSections(in tableView: UITableView) -> Int { 1 }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        tableView == infoTableView ? 4 : viewModel.transactions.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if tableView == infoTableView {
//            switch indexPath.row {
//            case 0, 1, 3:
//                let cell = tableView.dequeueReusableCell(withIdentifier: PeriodInfoTableViewCell.identifier, for: indexPath) as! PeriodInfoTableViewCell
//                if indexPath.row == 0 {
//                    cell.configure(title: "Начало", value: dateFormatter.string(from: viewModel.startDate), date: viewModel.startDate, showBackground: true)
//                    cell.onDateChanged = { [weak self] date in
//                        self?.viewModel.startDate = date
//                    }
//                } else if indexPath.row == 1 {
//                    cell.configure(title: "Конец", value: dateFormatter.string(from: viewModel.endDate), date: viewModel.endDate, showBackground: true)
//                    cell.onDateChanged = { [weak self] date in
//                        self?.viewModel.endDate = date
//                    }
//                } else if indexPath.row == 3 {
//                    cell.configure(title: "Сумма", value: "\(viewModel.total) ₽", date: nil, showBackground: false)
//                    cell.selectionStyle = .none
//                }
//                return cell
//
//            case 2:
//                let cell = UITableViewCell(style: .default, reuseIdentifier: "SortCell")
//                if cell.contentView.subviews.isEmpty {
//                    let control = UISegmentedControl(items: TransactionAnalizeViewModel.SortType.allCases.map { $0.rawValue })
//                    control.selectedSegmentIndex = TransactionAnalizeViewModel.SortType.allCases.firstIndex(of: viewModel.sortType) ?? 0
//                    control.addTarget(self, action: #selector(sortTypeChanged(_:)), for: .valueChanged)
//
//                    control.translatesAutoresizingMaskIntoConstraints = false
//                    control.selectedSegmentTintColor = UIColor.systemGray6
//
//                    cell.contentView.addSubview(control)
//
//                    NSLayoutConstraint.activate([
//                        control.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
//                        control.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
//                        control.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
//                        control.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),
//                        control.heightAnchor.constraint(equalToConstant: 32)
//                    ])
//                }
//                cell.selectionStyle = .none
//                return cell
//
//            default:
//                return UITableViewCell()
//            }
//        } else {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier, for: indexPath) as? TransactionTableViewCell else {
//                return UITableViewCell()
//            }
//
//            let transaction = viewModel.transactions[indexPath.row]
//            let totalAmount = viewModel.total
//
//            let percent: Double
//            if totalAmount > 0 {
//                percent = (Double(truncating: transaction.amount as NSNumber) / Double(truncating: totalAmount as NSNumber)) * 100
//            } else {
//                percent = 0
//            }
//
//            cell.configure(with: transaction, percent: percent)
//            return cell
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView == infoTableView, indexPath.row == 0 || indexPath.row == 1 {
//            guard let cell = tableView.cellForRow(at: indexPath) as? PeriodInfoTableViewCell else { return }
//            cell.showDatePicker()
//        } else if tableView == operationsTableView {
//            let transaction = viewModel.transactions[indexPath.row]
//            openEditor(for: transaction)
//        }
//
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if tableView == infoTableView {
//            let label = UILabel()
//            label.text = "Анализ"
//            label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
//            label.textColor = .label
//            label.frame = CGRect(x: 16, y: 0, width: tableView.bounds.width, height: 44)
//            return label
//        } else if tableView == operationsTableView {
//            let label = UILabel()
//            label.text = "Операции"
//            label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
//            label.textColor = .secondaryLabel
//            label.frame = CGRect(x: 16, y: 0, width: tableView.bounds.width, height: 20)
//            return label
//        }
//        return nil
//    }
//
//
//
//    @objc private func sortTypeChanged(_ sender: UISegmentedControl) {
//        let selectedType = TransactionAnalizeViewModel.SortType.allCases[sender.selectedSegmentIndex]
//        viewModel.sortType = selectedType
//        Task {
//            await viewModel.loadTransactions()
//            DispatchQueue.main.async {
//                self.operationsTableView.reloadData()
//            }
//        }
//    }
//}

import SwiftUI
import UIKit

class AnalysisViewController: UIViewController {
    private let viewModel: TransactionAnalizeViewModel
    private let infoTableView = UITableView(frame: .zero, style: .insetGrouped)
    private let operationsTableView = UITableView(frame: .zero, style: .insetGrouped)
    private let spinner = UIActivityIndicatorView(style: .large)
    private var infoTableHeightConstraint: NSLayoutConstraint!

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()

    init(direction: Direction, accountId: Int) {
        self.viewModel = TransactionAnalizeViewModel(accountId: accountId, direction: direction)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSpinner()
        loadTransactions()

        viewModel.triggerReload = { [weak self] in
            DispatchQueue.main.async {
                self?.infoTableView.reloadData()
                self?.operationsTableView.reloadData()
                self?.updateInfoTableHeight()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self?.infoTableView.reloadData()
                self?.operationsTableView.reloadData()
                self?.updateInfoTableHeight()
            }
        }
    }

    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground

        infoTableView.dataSource = self
        infoTableView.delegate = self
        infoTableView.isScrollEnabled = false
        infoTableView.register(PeriodInfoTableViewCell.self, forCellReuseIdentifier: PeriodInfoTableViewCell.identifier)
        infoTableView.register(PieChartTableViewCell.self, forCellReuseIdentifier: PieChartTableViewCell.identifier)

        operationsTableView.dataSource = self
        operationsTableView.delegate = self
        operationsTableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionTableViewCell.identifier)

        infoTableView.translatesAutoresizingMaskIntoConstraints = false
        operationsTableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(infoTableView)
        view.addSubview(operationsTableView)

        infoTableHeightConstraint = infoTableView.heightAnchor.constraint(equalToConstant: 250)

        NSLayoutConstraint.activate([
            infoTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -50),
            infoTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoTableHeightConstraint,

            operationsTableView.topAnchor.constraint(equalTo: infoTableView.bottomAnchor),
            operationsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            operationsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            operationsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupSpinner() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func updateInfoTableHeight() {
        infoTableView.layoutIfNeeded()
        infoTableHeightConstraint.constant = infoTableView.contentSize.height
        view.layoutIfNeeded()
    }

    private func openEditor(for transaction: Transaction) {
        let editorView = TransactionEditorView(
            mode: .edit(transaction),
            transactionService: AppServices.shared.transactionsService,
            accountService: AppServices.shared.bankAccountsService,
            categoriesService: AppServices.shared.categoriesService,
            direction: transaction.category.income
        ) {
            Task { await self.loadTransactions() }
        }

        let hostingController = UIHostingController(rootView: editorView)
        present(hostingController, animated: true)
    }

    private func loadTransactions() {
        spinner.startAnimating()
        Task {
            do {
                try await viewModel.loadTransactions()
                DispatchQueue.main.async {
                    self.infoTableView.reloadData()
                    self.operationsTableView.reloadData()
                    self.updateInfoTableHeight()
                    self.spinner.stopAnimating()
                }
            } catch {
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    self.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
}

extension AnalysisViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView == infoTableView ? 5 : viewModel.transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == infoTableView {
            switch indexPath.row {
            case 0, 1, 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: PeriodInfoTableViewCell.identifier, for: indexPath) as! PeriodInfoTableViewCell
                if indexPath.row == 0 {
                    cell.configure(title: "Начало", value: dateFormatter.string(from: viewModel.startDate), date: viewModel.startDate, showBackground: true)
                    cell.onDateChanged = { [weak self] date in
                        self?.viewModel.startDate = date
                    }
                } else if indexPath.row == 1 {
                    cell.configure(title: "Конец", value: dateFormatter.string(from: viewModel.endDate), date: viewModel.endDate, showBackground: true)
                    cell.onDateChanged = { [weak self] date in
                        self?.viewModel.endDate = date
                    }
                } else if indexPath.row == 3 {
                    cell.configure(title: "Сумма", value: "\(viewModel.total) ₽", date: nil, showBackground: false)
                    cell.selectionStyle = .none
                }
                return cell

            case 2:
                let cell = UITableViewCell(style: .default, reuseIdentifier: "SortCell")
                if cell.contentView.subviews.isEmpty {
                    let control = UISegmentedControl(items: TransactionAnalizeViewModel.SortType.allCases.map { $0.rawValue })
                    control.selectedSegmentIndex = TransactionAnalizeViewModel.SortType.allCases.firstIndex(of: viewModel.sortType) ?? 0
                    control.addTarget(self, action: #selector(sortTypeChanged(_:)), for: .valueChanged)
                    control.translatesAutoresizingMaskIntoConstraints = false
                    control.selectedSegmentTintColor = UIColor.systemGray6
                    cell.contentView.addSubview(control)

                    NSLayoutConstraint.activate([
                        control.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                        control.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                        control.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
                        control.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),
                        control.heightAnchor.constraint(equalToConstant: 32)
                    ])
                }
                cell.selectionStyle = .none
                return cell

            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: PieChartTableViewCell.identifier, for: indexPath) as! PieChartTableViewCell
                cell.configure(entities: viewModel.pieChartEntities)

                return cell

            default:
                return UITableViewCell()
            }
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier, for: indexPath) as? TransactionTableViewCell else {
                return UITableViewCell()
            }

            let transaction = viewModel.transactions[indexPath.row]
            let totalAmount = viewModel.total
            let percent = totalAmount > 0 ? (Double(truncating: transaction.amount as NSNumber) / Double(truncating: totalAmount as NSNumber)) * 100 : 0
            cell.configure(with: transaction, percent: percent)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == infoTableView, indexPath.row == 0 || indexPath.row == 1 {
            (tableView.cellForRow(at: indexPath) as? PeriodInfoTableViewCell)?.showDatePicker()
        } else if tableView == operationsTableView {
            openEditor(for: viewModel.transactions[indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        if tableView == infoTableView {
            label.text = "Анализ"
            label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
            label.textColor = .label
            label.frame = CGRect(x: 16, y: 0, width: tableView.bounds.width, height: 44)
        } else if tableView == operationsTableView {
            label.text = "Операции"
            label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
            label.textColor = .secondaryLabel
            label.frame = CGRect(x: 16, y: 0, width: tableView.bounds.width, height: 20)
        }
        return label
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard tableView == infoTableView else { return UITableView.automaticDimension }
        if indexPath.row == 4 { return 224 }
        return UITableView.automaticDimension
    }

    @objc private func sortTypeChanged(_ sender: UISegmentedControl) {
        let selectedType = TransactionAnalizeViewModel.SortType.allCases[sender.selectedSegmentIndex]
        viewModel.sortType = selectedType
        Task {
            await viewModel.loadTransactions()
            DispatchQueue.main.async {
                self.operationsTableView.reloadData()
            }
        }
    }
}


final class PieChartTableViewCell: UITableViewCell {
    static let identifier = "PieChartTableViewCell"

    private let chartView = PieChart.PieChartUIKitView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        contentView.addSubview(chartView)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .systemBackground
        chartView.backgroundColor = .clear

        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            chartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            chartView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            chartView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    /// Конфигурируем ячейку данными для PieChart
    func configure(entities: [PieChart.PieChartEntity]) {
        chartView.entities = entities
    }
}


//class PieChartUIKitView: UIView {
//
//    var entities: [PieChartEntity] = [] {
//        didSet {
//            setNeedsDisplay()
//        }
//    }
//
//    private let segmentColors: [UIColor] = [
//        .systemGreen, .systemYellow, .systemBlue,
//        .systemOrange, .systemPurple, .systemGray
//    ]
//
//    // MARK: - Init
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        commonInit()
//    }
//
//    private func commonInit() {
//        backgroundColor = .clear
//        isOpaque = false
//        contentMode = .redraw
//    }
//
//    override func draw(_ rect: CGRect) {
//        guard let context = UIGraphicsGetCurrentContext(), !entities.isEmpty else { return }
//
//        // Заливка фона системным цветом (для поддержки тёмной/светлой темы)
//        UIColor.systemBackground.setFill()
//        context.fill(rect)
//
//        let radius = min(bounds.width, bounds.height) / 2 - 20
//        let center = CGPoint(x: bounds.midX, y: bounds.midY)
//        let lineWidth: CGFloat = 13
//        let total = entities.reduce(Decimal(0)) { $0 + $1.value }
//        guard total > 0 else { return }
//
//        var displayEntities: [PieChartEntity] = []
//
//        let topEntities = entities.prefix(5)
//        for entity in topEntities {
//            let percent = (NSDecimalNumber(decimal: entity.value).doubleValue /
//                          NSDecimalNumber(decimal: total).doubleValue) * 100
//            displayEntities.append(
//                PieChartEntity(value: entity.value, label: entity.label, percent: percent)
//            )
//        }
//
//        if entities.count > 5 {
//            let othersValue = entities.dropFirst(5).reduce(Decimal(0)) { $0 + $1.value }
//            let othersPercent = (NSDecimalNumber(decimal: othersValue).doubleValue /
//                                NSDecimalNumber(decimal: total).doubleValue) * 100
//            displayEntities.append(
//                PieChartEntity(value: othersValue, label: "Остальные", percent: othersPercent)
//            )
//        }
//
//
//        var startAngle = -CGFloat.pi / 2
//
//        for (index, entity) in displayEntities.enumerated() {
//            let fraction = CGFloat((entity.value / total) as NSDecimalNumber)
//            let endAngle = startAngle + 2 * .pi * fraction
//
//            context.setStrokeColor(segmentColors[index % segmentColors.count].cgColor)
//            context.setLineWidth(lineWidth)
//            context.setLineCap(.butt)
//            context.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
//            context.strokePath()
//
//            startAngle = endAngle
//        }
//
//        drawLegend(in: context, center: center, entities: displayEntities, total: total)
//    }
//
//    private func drawLegend(in context: CGContext, center: CGPoint, entities: [PieChartEntity], total: Decimal) {
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = .left
//
//        let font = UIFont.systemFont(ofSize: 12)
//        let legendSize = CGSize(width: 120, height: CGFloat(entities.count) * 20)
//
//        let startY = center.y - legendSize.height / 2
//        for (index, entity) in entities.enumerated() {
//            let percentage = entity.percent
//            let text = String(format: "%.0f%% %@", percentage, entity.label)
//            let point = CGPoint(x: center.x - 50, y: startY + CGFloat(index) * 20)
//
//            let dotRect = CGRect(x: point.x, y: point.y + 4, width: 8, height: 8)
//            let path = UIBezierPath(ovalIn: dotRect)
//            segmentColors[index % segmentColors.count].setFill()
//            path.fill()
//
//            let textRect = CGRect(x: point.x + 14, y: point.y, width: 100, height: 16)
//            let attributes: [NSAttributedString.Key: Any] = [
//                .font: font,
//                .paragraphStyle: paragraphStyle,
//                .foregroundColor: UIColor.label
//            ]
//            (text as NSString).draw(in: textRect, withAttributes: attributes)
//        }
//    }
//}
//
//
//struct PieChartEntity {
//    let value: Decimal
//    let label: String
//    let percent: Double
//}
