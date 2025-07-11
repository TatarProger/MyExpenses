//
//  PeriodInfoView.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 11.07.2025.
//

import UIKit

class PeriodInfoView: UIView {
    enum DateType {
        case startDate
        case endDate
    }

    var onDateChanged: ((Date) -> Void)?
    var dateType: DateType?

    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let hiddenTextField = UITextField()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupDatePicker()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
        setupDatePicker()
    }

    private func setupLayout() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.masksToBounds = true

        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .label

        valueLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        valueLabel.textAlignment = .center
        valueLabel.backgroundColor = UIColor.mintAccent
        valueLabel.layer.cornerRadius = 8
        valueLabel.layer.masksToBounds = true
        valueLabel.setContentHuggingPriority(.required, for: .horizontal)

        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center

        addSubview(stack)
        addSubview(hiddenTextField)

        stack.translatesAutoresizingMaskIntoConstraints = false
        hiddenTextField.translatesAutoresizingMaskIntoConstraints = false
        hiddenTextField.isHidden = true

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            valueLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
            valueLabel.heightAnchor.constraint(equalToConstant: 28)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(showDatePicker))
        addGestureRecognizer(tap)
    }

    private func setupDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        }
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        hiddenTextField.inputView = datePicker

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(closeDatePicker))
        toolbar.setItems([doneButton], animated: false)
        hiddenTextField.inputAccessoryView = toolbar
    }

    func configure(title: String, value: String, dateType: DateType? = nil, showBackground: Bool = true) {
        titleLabel.text = title
        valueLabel.text = value
        self.dateType = dateType

        valueLabel.backgroundColor = showBackground ? UIColor.mintAccent : .clear
        valueLabel.layer.cornerRadius = showBackground ? 8 : 0
    }

    func updateValue(_ newValue: String) {
        valueLabel.text = newValue
    }

    @objc private func showDatePicker() {
        hiddenTextField.becomeFirstResponder()
    }

    @objc private func dateChanged(_ sender: UIDatePicker) {
        onDateChanged?(sender.date)
    }

    @objc private func closeDatePicker() {
        hiddenTextField.resignFirstResponder()
    }
}
