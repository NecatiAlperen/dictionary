//
//  SynonymCell.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 10.06.2024.
//

import UIKit

final class SynonymCell: UICollectionViewCell {
    static let identifier = "SynonymCell"
    
    //MARK: -- COMPONENTS
    private lazy var background: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var synonymLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.Fonts.body
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    //MARK: -- LIFECYCLES
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -- FUNCTIONS
    func setupCell() {
        contentView.addSubview(background)
        background.addSubview(synonymLabel)
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: contentView.topAnchor),
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            synonymLabel.topAnchor.constraint(equalTo: background.topAnchor, constant: 5),
            synonymLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 10),
            synonymLabel.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -10),
            synonymLabel.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -5)
        ])
    }
    
    func configure(with word: String) {
        synonymLabel.text = word
    }
}





