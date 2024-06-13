//
//  SynonymCell.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 10.06.2024.
//

import UIKit

final class SynonymCell: UICollectionViewCell {
    static let identifier = "SynonymCell"
    
    private let synonymLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = Theme.Fonts.body
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let background: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(background)
        background.addSubview(synonymLabel)
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: contentView.topAnchor),
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            synonymLabel.topAnchor.constraint(equalTo: background.topAnchor, constant: 2),
            synonymLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 8),
            synonymLabel.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -8),
            synonymLabel.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -2)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with synonym: Synonym) {
        synonymLabel.text = synonym.word
    }
}




