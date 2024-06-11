//
//  HomeInteractor.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 8.06.2024.
//

import Foundation

protocol HomeInteractorProtocol {
    func searchWord(_ word: String)
    func saveRecentSearch(_ word: String)
    func getRecentSearches() -> [String]
}

protocol HomeInteractorOutputProtocol: AnyObject {
    func didFetchWordDetails(_ details: [WordDetail])
    func didFailToFetchWordDetails(with error: Error)
}

final class HomeInteractor {
    weak var output: HomeInteractorOutputProtocol?
}

extension HomeInteractor: HomeInteractorProtocol {
    func searchWord(_ word: String) {
        NetworkService.shared.fetchWordDetails(word: word) { [weak self] result in
            switch result {
            case .success(let details):
                self?.saveRecentSearch(word)
                self?.output?.didFetchWordDetails(details)
            case .failure(let error):
                self?.output?.didFailToFetchWordDetails(with: error)
            }
        }
    }
    
    func saveRecentSearch(_ word: String) {
        var recentSearches = getRecentSearches()
        if let index = recentSearches.firstIndex(of: word) {
            recentSearches.remove(at: index)
        }
        recentSearches.insert(word, at: 0)
        if recentSearches.count > 5 {
            recentSearches.removeLast()
        }
        UserDefaults.standard.set(recentSearches, forKey: "RecentSearches")
    }
    
    func getRecentSearches() -> [String] {
        return UserDefaults.standard.stringArray(forKey: "RecentSearches") ?? []
    }
}

