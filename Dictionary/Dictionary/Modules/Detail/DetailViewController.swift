//
//  DetailViewController.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 9.06.2024.
//

import UIKit
import AVFoundation
import SafariServices

protocol DetailViewControllerProtocol: AnyObject {
    func showDetails(_ details: [WordDetail])
    func showSynonyms(_ synonyms: [Synonym])
    func updateFilterButtons(with titles: [String], selectedFilters: [String])
    func reloadTableView()
    func showError(_ message: String)
    func showPersonButton(_ visible: Bool)
    var word: String { get }
}

final class DetailViewController: BaseViewController {
    var presenter: DetailPresenterProtocol!
    var word: String = ""
    
    //MARK: -- COMPONENTS
    private lazy var wordLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.headline
        label.textColor = Theme.Colors.navy
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var phoneticLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var personButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "person.wave.2.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = Theme.Colors.navy
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapPersonButton), for: .touchUpInside)
        return button
    }()
    private lazy var clearButton: UIButton = {
        let button = UIButton()
        button.setTitle("✖️", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapClearButton), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    private lazy var filterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.Colors.greyBackground
        view.addSubview(wordLabel)
        view.addSubview(personButton)
        view.addSubview(phoneticLabel)
        view.addSubview(filterStackView)
        
        NSLayoutConstraint.activate([
            wordLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            wordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            personButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            personButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            phoneticLabel.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 8),
            phoneticLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            filterStackView.topAnchor.constraint(equalTo: phoneticLabel.bottomAnchor, constant: 16),
            filterStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            filterStackView.heightAnchor.constraint(equalToConstant: 30)
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
    
    //MARK: --  LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        presenter.viewDidLoad()
    }
    //MARK: --  FUNCTIONS
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
        
        let networkButton = UIBarButtonItem(image: UIImage(systemName: "network"), style: .plain, target: self, action: #selector(didTapNetworkButton))
        navigationItem.rightBarButtonItem = networkButton
    }
    
    @objc private func didTapNetworkButton() {
        presenter.networkButtonTapped()
    }
    
    @objc private func didTapPersonButton() {
        presenter.playAudio()
    }
    
    @objc private func didTapClearButton() {
        presenter.clearFilter()
    }
    
    private func createFilterButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.clear.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func filterButtonTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal)?.lowercased() else { return }
        presenter.filterButtonTapped(with: title)
    }
    
    func updateFilterButtons(with titles: [String], selectedFilters: [String]) {
        filterStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        filterStackView.addArrangedSubview(clearButton)
        titles.forEach { title in
            let button = createFilterButton(title: title)
            filterStackView.addArrangedSubview(button)
        }
        updateFilterButtonSelections(selectedFilters: selectedFilters)
    }
    
    private func updateFilterButtonSelections(selectedFilters: [String]) {
        filterStackView.arrangedSubviews.forEach { view in
            if let button = view as? UIButton {
                let title = button.title(for: .normal)?.lowercased() ?? ""
                button.layer.borderColor = selectedFilters.contains(title) ? Theme.Colors.navy.cgColor : Theme.Colors.white.cgColor
            }
        }
        clearButton.isHidden = selectedFilters.isEmpty
    }
    
    func showPersonButton(_ visible: Bool) {
        personButton.isHidden = !visible
    }
}

extension DetailViewController: DetailViewControllerProtocol {
    
    func showDetails(_ details: [WordDetail]) {
        wordLabel.text = details.first?.word
        phoneticLabel.text = details.first?.phonetics.first?.text
        presenter.updateFilteredMeanings(details)
        presenter.filterButtonsSetup()
        reloadTableView()
    }
    
    func showSynonyms(_ synonyms: [Synonym]) {
        reloadTableView()
    }
    
    func updateFilterButtons(selectedFilters: [String]) {
        updateFilterButtonSelections(selectedFilters: selectedFilters)
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return presenter.cellForRow(at: indexPath, in: tableView)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}



