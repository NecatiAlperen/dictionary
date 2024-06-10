//
//  DetailViewController.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 9.06.2024.
//

import UIKit

protocol DetailViewControllerProtocol: AnyObject {
    func showDetails(_ details: [WordDetail])
}

final class DetailViewController: BaseViewController {
    
    var presenter: DetailPresenterProtocol!
    var details: [WordDetail]?
    var synonyms: [String] = ["house", "family", "base", "place", "plate","car"]

    private lazy var wordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var phoneticLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var personButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "person.wave.2.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nounButton: UIButton = {
        let button = UIButton()
        button.setTitle("Noun", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var verbButton: UIButton = {
        let button = UIButton()
        button.setTitle("Verb", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var adjectiveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Adjective", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(wordLabel)
        view.addSubview(personButton)
        view.addSubview(phoneticLabel)
        view.addSubview(nounButton)
        view.addSubview(verbButton)
        view.addSubview(adjectiveButton)
        
        NSLayoutConstraint.activate([
            wordLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            wordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            personButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            personButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            phoneticLabel.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 8),
            phoneticLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            nounButton.topAnchor.constraint(equalTo: phoneticLabel.bottomAnchor, constant: 16),
            nounButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nounButton.heightAnchor.constraint(equalToConstant: 30),
            nounButton.widthAnchor.constraint(equalToConstant: 80),
            
            verbButton.topAnchor.constraint(equalTo: phoneticLabel.bottomAnchor, constant: 16),
            verbButton.leadingAnchor.constraint(equalTo: nounButton.trailingAnchor, constant: 16),
            verbButton.heightAnchor.constraint(equalToConstant: 30),
            verbButton.widthAnchor.constraint(equalToConstant: 80),
            
            adjectiveButton.topAnchor.constraint(equalTo: phoneticLabel.bottomAnchor, constant: 16),
            adjectiveButton.leadingAnchor.constraint(equalTo: verbButton.trailingAnchor, constant: 16),
            adjectiveButton.heightAnchor.constraint(equalToConstant: 30),
            adjectiveButton.widthAnchor.constraint(equalToConstant: 80),
        ])
        
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WordDetailCell.self, forCellReuseIdentifier: WordDetailCell.identifier)
        tableView.register(SynonymTableViewCell.self, forCellReuseIdentifier: SynonymTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        presenter.viewDidLoad()
    }
    
    func setupViews() {
        view.addSubview(headerView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 150),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension DetailViewController: DetailViewControllerProtocol {
    func showDetails(_ details: [WordDetail]) {
        self.details = details
        if let firstDetail = details.first {
            wordLabel.text = firstDetail.word
            phoneticLabel.text = firstDetail.phonetics.first?.text
        }
        tableView.reloadData()
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4 
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let details = details else { return 0 }
        let meanings = details.flatMap { $0.meanings }
        
        switch section {
        case 0:
            return Array(meanings.filter { $0.partOfSpeech == "noun" }.prefix(3)).count
        case 1:
            return Array(meanings.filter { $0.partOfSpeech == "verb" }.prefix(2)).count
        case 2:
            return Array(meanings.filter { $0.partOfSpeech == "adjective" }.prefix(2)).count
        case 3:
            return 1
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SynonymTableViewCell.identifier, for: indexPath) as? SynonymTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: synonyms)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WordDetailCell.identifier, for: indexPath) as? WordDetailCell else {
                return UITableViewCell()
            }
            if let details = details {
                let meanings = details.flatMap { $0.meanings }
                var filteredMeanings: [Meaning] = []
                switch indexPath.section {
                case 0:
                    filteredMeanings = Array(meanings.filter { $0.partOfSpeech == "noun" }.prefix(3))
                case 1:
                    filteredMeanings = Array(meanings.filter { $0.partOfSpeech == "verb" }.prefix(2))
                case 2:
                    filteredMeanings = Array(meanings.filter { $0.partOfSpeech == "adjective" }.prefix(2))
                default:
                    break
                }
                cell.configure(with: filteredMeanings[indexPath.row])
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Noun"
        case 1:
            return "Verb"
        case 2:
            return "Adjective"
        default:
            return nil
        }
    }
}



