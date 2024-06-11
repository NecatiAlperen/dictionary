//
//  SynonymCell.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 10.06.2024.
//

import UIKit

final class SynonymCell: UICollectionViewCell {
    static let identifier = "SynonymCell"
    
    private lazy var synonymLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(synonymLabel)
        
        NSLayoutConstraint.activate([
            synonymLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            synonymLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            synonymLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            synonymLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with synonym: String) {
        synonymLabel.text = synonym
    }
}


