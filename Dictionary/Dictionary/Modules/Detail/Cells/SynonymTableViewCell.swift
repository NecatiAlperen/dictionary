//
//  SynonymTableViewCell.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 10.06.2024.
//

import UIKit

final class SynonymTableViewCell: UITableViewCell {
    static let identifier = "SynonymTableViewCell"

    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Synonyms"
        label.textColor = Theme.Colors.navy
        label.textAlignment = .left
        label.font = Theme.Fonts.headline
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SynonymCell.self, forCellWithReuseIdentifier: SynonymCell.identifier)
        return collectionView
    }()
    
    private var synonyms: [Synonym] = []
    var didSelectSynonym: ((String) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configure(with synonyms: [Synonym]) {
        self.synonyms = Array(synonyms.sorted(by: { $0.score > $1.score }).prefix(5))
        collectionView.reloadData()
    }
}

extension SynonymTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return synonyms.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SynonymCell.identifier, for: indexPath) as? SynonymCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: synonyms[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectSynonym?(synonyms[indexPath.item].word)
    }
}


