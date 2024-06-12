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
    func showSynonyms(_ synonyms: [String])
    // set table views delegate
    var word: String { get }
}

final class DetailViewController: BaseViewController {

    var presenter: DetailPresenterProtocol!
    var details: [WordDetail]?
    var synonyms: [Synonym] = []
    var word: String = ""
    var filteredMeanings: [Meaning] = []
    var selectedFilters: [String] = []
    var player: AVPlayer?

    private lazy var wordLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.headline
        label.textColor = Theme.Colors.primary
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
        button.setTitle("✖️", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clearFilter), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    private lazy var filterStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [clearButton, nounButton, verbButton, adjectiveButton, adverbButton])
        stackView.axis = .horizontal
        stackView.spacing = 16
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

            personButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
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
        
        let networkButton = UIBarButtonItem(image: UIImage(systemName: "network"), style: .plain, target: self, action: #selector(networkButtonTapped))
        navigationItem.rightBarButtonItem = networkButton
    }

    @objc private func networkButtonTapped() {
        guard let sourceUrl = details?.first?.sourceUrls?.first, let url = URL(string: sourceUrl) else {
            let alert = UIAlertController(title: "Error", message: "No valid URL found.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
            // presnter protcol nutton tappped
        }

        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }

    @objc private func playAudio() {
        guard let phonetic = details?.first?.phonetics.first(where: { $0.audio?.isEmpty == false }), let audioUrl = phonetic.audio, let url = URL(string: audioUrl) else {
            personButton.isHidden = true
            return
        }
        player = AVPlayer(url: url)
        player?.play()
        // view.auido
    }

    private func createFilterButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.black.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        return button
    }

    @objc private func filterButtonTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal)?.lowercased() else { return }

        if selectedFilters.contains(title) {
            selectedFilters.removeAll(where: { $0 == title })
        } else {
            selectedFilters.append(title)
        }

        updateFilteredMeanings()
        updateFilterButtons()
        tableView.reloadData()
        //presenter.filterbuttontap
    }

    @objc private func clearFilter() {
        if !selectedFilters.isEmpty {
            selectedFilters.removeLast()
            updateFilteredMeanings()
            updateFilterButtons()
            tableView.reloadData()
        } // yukarı aynı
    }

    private func updateFilteredMeanings() {
        guard let details = details else { return }
        var allMeanings: [Meaning] = []

        for detail in details {
            for meaning in detail.meanings {
                if selectedFilters.isEmpty || selectedFilters.contains(meaning.partOfSpeech?.lowercased() ?? "") {
                    allMeanings.append(contentsOf: meaning.definitions.map { definition in
                        Meaning(partOfSpeech: meaning.partOfSpeech, definitions: [definition])
                    })
                }
            } // aynı
        }
        
        filteredMeanings = allMeanings
    }

    private func updateFilterButtons() {
        nounButton.layer.borderColor = selectedFilters.contains("noun") ? Theme.Colors.primary.cgColor : UIColor.black.cgColor
        verbButton.layer.borderColor = selectedFilters.contains("verb") ? Theme.Colors.primary.cgColor : UIColor.black.cgColor
        adjectiveButton.layer.borderColor = selectedFilters.contains("adjective") ? Theme.Colors.primary.cgColor : UIColor.black.cgColor
        adverbButton.layer.borderColor = selectedFilters.contains("adverb") ? Theme.Colors.primary.cgColor : UIColor.black.cgColor
        clearButton.isHidden = selectedFilters.isEmpty
        // present.selected filters ile taşı
    }

    private func filterButtonsSetup() {
        guard let details = details else { return }
        let meanings = details.flatMap { $0.meanings }
        let partsOfSpeech = Set(meanings.compactMap { $0.partOfSpeech?.lowercased() })

        nounButton.isHidden = !partsOfSpeech.contains("noun")
        verbButton.isHidden = !partsOfSpeech.contains("verb")
        adjectiveButton.isHidden = !partsOfSpeech.contains("adjective")
        adverbButton.isHidden = !partsOfSpeech.contains("adverb")
        // bak
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
    } // presenter.showdet(reload data)

    func showSynonyms(_ synonyms: [String]) {
        let synonymObjects = synonyms.map { Synonym(word: $0, score: Int.random(in: 0..<100)) }  
        self.synonyms = synonymObjects
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
            cell.didSelectSynonym = { [weak self] word in
                self?.presenter.loadWordDetails(for: word)
            }
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












