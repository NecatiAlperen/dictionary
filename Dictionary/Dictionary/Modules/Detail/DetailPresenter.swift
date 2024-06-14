//
//  DetailPresenter.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 9.06.2024.
//

import AVFoundation
import UIKit

protocol DetailPresenterProtocol {
    func viewDidLoad()
    func loadWordDetails(for word: String)
    func networkButtonTapped()
    func playAudio()
    func clearFilter()
    func filterButtonTapped(with title: String)
    func updateFilteredMeanings(_ details: [WordDetail])
    func filterButtonsSetup()
    func numberOfRows(in section: Int) -> Int
    func cellForRow(at indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell
}

final class DetailPresenter {
    
    //MARK: -- VARIABLES
    unowned var view: DetailViewControllerProtocol
    let router: DetailRouterProtocol
    let interactor: DetailInteractorProtocol
    private var details: [WordDetail] = []
    private var synonyms: [Synonym] = []
    private var filteredMeanings: [Meaning] = []
    private var selectedFilters: [String] = []
    var player: AVPlayer?

    init(view: DetailViewControllerProtocol, router: DetailRouterProtocol, interactor: DetailInteractorProtocol) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}

extension DetailPresenter: DetailPresenterProtocol {
    func viewDidLoad() {
        interactor.fetchDetails()
        interactor.fetchSynonyms(for: view.word)
    }

    func loadWordDetails(for word: String) {
        interactor.fetchWordDetails(for: word)
    }

    func networkButtonTapped() {
        guard let sourceUrl = details.first?.sourceUrls?.first, let url = URL(string: sourceUrl) else {
            view.showError("No valid URL found.")
            return
        }
        router.presentSafariViewController(with: url)
    }

    func playAudio() {
        guard let phonetic = details.first?.phonetics.first(where: { $0.audio?.isEmpty == false }), let audioUrl = phonetic.audio, let url = URL(string: audioUrl) else {
            view.showError("Audio not found.")
            return
        }
        player = AVPlayer(url: url)
        player?.play()
    }

    func clearFilter() {
        if !selectedFilters.isEmpty {
            selectedFilters.removeLast()
            updateFilteredMeanings(details)
            view.updateFilterButtons(with: partsOfSpeech(from: details), selectedFilters: selectedFilters)
            view.reloadTableView()
        }
    }

    func filterButtonTapped(with title: String) {
        if selectedFilters.contains(title) {
            selectedFilters.removeAll(where: { $0 == title })
        } else {
            selectedFilters.append(title)
        }
        updateFilteredMeanings(details)
        view.updateFilterButtons(with: partsOfSpeech(from: details), selectedFilters: selectedFilters)
        view.reloadTableView()
    }

    func updateFilteredMeanings(_ details: [WordDetail]) {
        var allMeanings: [Meaning] = []
        for detail in details {
            for meaning in detail.meanings {
                if selectedFilters.isEmpty || selectedFilters.contains(meaning.partOfSpeech?.lowercased() ?? "") {
                    allMeanings.append(contentsOf: meaning.definitions.map { definition in
                        Meaning(partOfSpeech: meaning.partOfSpeech, definitions: [definition])
                    })
                }
            }
        }
        filteredMeanings = allMeanings
    }

    func filterButtonsSetup() {
        let partsOfSpeech = self.partsOfSpeech(from: details)
        view.updateFilterButtons(with: partsOfSpeech, selectedFilters: selectedFilters)
    }

    private func partsOfSpeech(from details: [WordDetail]) -> [String] {
        let meanings = details.flatMap { $0.meanings }
        let partsOfSpeech = Set(meanings.compactMap { $0.partOfSpeech?.lowercased() })
        return Array(partsOfSpeech)
    }

    func numberOfRows(in section: Int) -> Int {
        switch section {
        case 0:
            return filteredMeanings.count
        case 1:
            return 1
        default:
            return 0
        }
    }

    func cellForRow(at indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SynonymTableViewCell.identifier, for: indexPath) as? SynonymTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: synonyms)
            cell.didSelectSynonym = { [weak self] word in
                self?.loadWordDetails(for: word)
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

extension DetailPresenter: DetailInteractorOutputProtocol {
    func didFetchDetails(_ details: [WordDetail]) {
        self.details = details
        view.showDetails(details)
        checkAndHidePersonButtonIfNeeded()
    }

    func didFetchSynonyms(_ synonyms: [Synonym]) {
        self.synonyms = synonyms
        view.showSynonyms(synonyms)
    }

    func didFetchWordDetails(_ details: [WordDetail], synonyms: [Synonym]) {
        self.details = details
        self.synonyms = synonyms
        view.showDetails(details)
        view.showSynonyms(synonyms)
        checkAndHidePersonButtonIfNeeded()
    }
    
    private func checkAndHidePersonButtonIfNeeded() {
        let hasAudio = details.first?.phonetics.first(where: { $0.audio != nil && !$0.audio!.isEmpty }) != nil
        view.showPersonButton(hasAudio)
    }
}



