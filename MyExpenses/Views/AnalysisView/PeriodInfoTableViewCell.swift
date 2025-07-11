//
//  PeriodInfoTableViewCell.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 11.07.2025.
//

import UIKit

class PeriodInfoTableViewCell: UITableViewCell {
    static let identifier = "PeriodInfoTableViewCell"

    var onDateChanged: ((Date) -> Void)?

    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let hiddenTextField = UITextField()

    private var datePicker: UIDatePicker?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupDatePicker()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        contentView.addSubview(hiddenTextField)

        hiddenTextField.isHidden = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        hiddenTextField.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = UIFont.systemFont(ofSize: 18)
        valueLabel.font = UIFont.systemFont(ofSize: 16)
        valueLabel.backgroundColor = UIColor.systemMint.withAlphaComponent(0.3)
        valueLabel.layer.cornerRadius = 10
        valueLabel.layer.masksToBounds = true
        valueLabel.textAlignment = .center

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            valueLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 120),
            valueLabel.heightAnchor.constraint(equalToConstant: 32),
        ])
    }

    private func setupDatePicker() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        if #available(iOS 14.0, *) {
            datePicker?.preferredDatePickerStyle = .inline
        }
        hiddenTextField.inputView = datePicker

        datePicker?.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(donePressed))
        ]
        hiddenTextField.inputAccessoryView = toolbar
    }
    
    func configure(title: String, value: String, date: Date?, showBackground: Bool = true) {
        titleLabel.text = title
        valueLabel.text = value

        if let date = date {
            datePicker?.date = date
        }

        valueLabel.backgroundColor = showBackground ? UIColor.mintAccent : .clear
        valueLabel.layer.cornerRadius = showBackground ? 10 : 0
    }

    func showDatePicker() {
        hiddenTextField.becomeFirstResponder()
    }

    @objc private func dateChanged(_ sender: UIDatePicker) {
        onDateChanged?(sender.date)
        
        // Немедленно обновляем текст valueLabel внутри ячейки
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy"
        valueLabel.text = formatter.string(from: sender.date)
    }


    @objc private func donePressed() {
        hiddenTextField.resignFirstResponder()
    }
}
