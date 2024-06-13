//
//  DetailTableViewCell.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 9.06.2024.
//


import UIKit

final class WordDetailCell: UITableViewCell {
    static let identifier = "WordDetailCell"

    private lazy var partOfSpeechLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.body
        label.textColor = Theme.Colors.orange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    private lazy var definitionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Theme.Colors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var exampleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [partOfSpeechLabel, definitionLabel, exampleLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        contentView.addSubview(verticalStackView)
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with meaning: Meaning, label: String) {
        partOfSpeechLabel.text = label
        definitionLabel.text = meaning.definitions.first?.definition
        exampleLabel.text = meaning.definitions.first?.example
    }
}

