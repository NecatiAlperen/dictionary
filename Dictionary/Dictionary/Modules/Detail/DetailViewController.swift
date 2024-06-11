//
//  DetailViewController.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 9.06.2024.
//

import UIKit
import AVFoundation

protocol DetailViewControllerProtocol: AnyObject {
    func showDetails(_ details: [WordDetail])
    func showSynonyms(_ synonyms: [String])
    var word: String { get }
}

final class DetailViewController: BaseViewController {

    var presenter: DetailPresenterProtocol!
    var details: [WordDetail]?
    var synonyms: [String] = []
    var word: String = ""
    var filteredMeanings: [Meaning] = []
    var selectedFilters: [String] = []
    var player: AVPlayer?

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
        button.addTarget(self, action: #selector(playAudio), for: .touchUpInside)
        return button
    }()

    private lazy var nounButton: UIButton = createFilterButton(title: "Noun")
    private lazy var verbButton: UIButton = createFilterButton(title: "Verb")
    private lazy var adjectiveButton: UIButton = createFilterButton(title: "Adjective")
    private lazy var adverbButton: UIButton = createFilterButton(title: "Adverb")
    private lazy var clearButton: UIButton = {
        let button = UIButton()
        button.setTitle("X", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clearFilter), for: .touchUpInside)
        button.isHidden = true
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
        view.addSubview(adverbButton)
        view.addSubview(clearButton)

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

            adverbButton.topAnchor.constraint(equalTo: phoneticLabel.bottomAnchor, constant: 16),
            adverbButton.leadingAnchor.constraint(equalTo: adjectiveButton.trailingAnchor, constant: 16),
            adverbButton.heightAnchor.constraint(equalToConstant: 30),
            adverbButton.widthAnchor.constraint(equalToConstant: 80),

            clearButton.topAnchor.constraint(equalTo: phoneticLabel.bottomAnchor, constant: 16),
            clearButton.leadingAnchor.constraint(equalTo: adverbButton.trailingAnchor, constant: 16),
            clearButton.heightAnchor.constraint(equalToConstant: 30),
            clearButton.widthAnchor.constraint(equalToConstant: 30),
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

    @objc private func playAudio() {
        guard let audioUrl = details?.first?.phonetics.first(where: { $0.audio != nil })?.audio, let url = URL(string: audioUrl) else {
            personButton.isHidden = true
            return
        }
        player = AVPlayer(url: url)
        player?.play()
    }

    private func createFilterButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        return button
    }

    @objc private func filterButtonTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }

        if selectedFilters.contains(title.lowercased()) {
            selectedFilters.removeAll(where: { $0 == title.lowercased() })
        } else {
            selectedFilters.append(title.lowercased())
        }

        updateFilteredMeanings()
        updateFilterButtons()
        tableView.reloadData()
    }

    @objc private func clearFilter() {
        if !selectedFilters.isEmpty {
            selectedFilters.removeLast()
            if selectedFilters.isEmpty {
                clearButton.isHidden = true
            }
            updateFilteredMeanings()
            updateFilterButtons()
            tableView.reloadData()
        }
    }

    private func updateFilteredMeanings() {
        guard let details = details else { return }
        var allMeanings: [Meaning] = []

        for detail in details {
            for meaning in detail.meanings {
                if selectedFilters.isEmpty || selectedFilters.contains(meaning.partOfSpeech ?? "") {
                    allMeanings.append(contentsOf: meaning.definitions.map { definition in
                        Meaning(partOfSpeech: meaning.partOfSpeech, definitions: [definition])
                    })
                }
            }
        }
        
        filteredMeanings = allMeanings
    }

    private func updateFilterButtons() {
        nounButton.backgroundColor = selectedFilters.contains("noun") ? .lightGray : .white
        verbButton.backgroundColor = selectedFilters.contains("verb") ? .lightGray : .white
        adjectiveButton.backgroundColor = selectedFilters.contains("adjective") ? .lightGray : .white
        adverbButton.backgroundColor = selectedFilters.contains("adverb") ? .lightGray : .white
        clearButton.isHidden = selectedFilters.isEmpty
    }

    private func filterButtonsSetup() {
        guard let details = details else { return }
        let meanings = details.flatMap { $0.meanings }
        let partsOfSpeech = Set(meanings.compactMap { $0.partOfSpeech })

        nounButton.isHidden = !partsOfSpeech.contains("noun")
        verbButton.isHidden = !partsOfSpeech.contains("verb")
        adjectiveButton.isHidden = !partsOfSpeech.contains("adjective")
        adverbButton.isHidden = !partsOfSpeech.contains("adverb")
    }
}

extension DetailViewController: DetailViewControllerProtocol {
    func showDetails(_ details: [WordDetail]) {
        self.details = details
        updateFilteredMeanings()
        if let firstDetail = details.first {
            wordLabel.text = firstDetail.word
            phoneticLabel.text = firstDetail.phonetics.first?.text
            if firstDetail.phonetics.first(where: { $0.audio != nil }) == nil {
                personButton.isHidden = true
            }
        }
        filterButtonsSetup()
        tableView.reloadData()
    }

    func showSynonyms(_ synonyms: [String]) {
        self.synonyms = synonyms
        tableView.reloadData()
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return filteredMeanings.count
        case 1:
            return 1
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SynonymTableViewCell.identifier, for: indexPath) as? SynonymTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: synonyms)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WordDetailCell.identifier, for: indexPath) as? WordDetailCell else {
                return UITableViewCell()
            }
            let meaning = filteredMeanings[indexPath.row]
            let label = "\(indexPath.row + 1) - \(meaning.partOfSpeech ?? "")"
            cell.configure(with: meaning, label: label)
            return cell
        }
    }
}




