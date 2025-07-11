//
//  TransactionTableViewCell.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 11.07.2025.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    static let identifier = "TransactionTableViewCell"

    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.5)
        label.textAlignment = .center
        label.backgroundColor = UIColor.mintAccent
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.isHidden = true
        return label
    }()
    
    private let percentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .label
        label.textAlignment = .right
        return label
    }()


    private let chevronImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .tertiaryLabel
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()


    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .label
        return label
    }()

    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        label.isHidden = true
        return label
    }()

    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .label
        label.textAlignment = .right
        return label
    }()

    private let stackView = UIStackView()
    private let leftStack = UIStackView()
    private let amountStack = UIStackView()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojiLabel)

        leftStack.axis = .vertical
        leftStack.spacing = 4
        leftStack.addArrangedSubview(categoryLabel)
        leftStack.addArrangedSubview(commentLabel)

        amountStack.axis = .vertical
        amountStack.spacing = 2
        amountStack.alignment = .trailing
        amountStack.addArrangedSubview(percentLabel)
        amountStack.addArrangedSubview(amountLabel)

        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.addArrangedSubview(leftStack)
        stackView.addArrangedSubview(amountStack)
        stackView.addArrangedSubview(chevronImageView)

        chevronImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        chevronImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true

        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),

            stackView.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }

    
    func configure(with transaction: Transaction, percent: Double) {
        categoryLabel.text = transaction.category.name
        amountLabel.text = "\(transaction.amount) ₽"
        percentLabel.text = String(format: "%.0f%%", percent)

        emojiLabel.isHidden = transaction.category.income != .outcome
        emojiLabel.text = String(transaction.category.emoji)

        commentLabel.isHidden = (transaction.comment ?? "").isEmpty
        commentLabel.text = transaction.comment
    }
}
