//
//  HomeInteractor.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 8.06.2024.
//

import Foundation

protocol HomeInteractorProtocol {
    func searchWord(_ word: String)
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
                self?.output?.didFetchWordDetails(details)
            case .failure(let error):
                self?.output?.didFailToFetchWordDetails(with: error)
            }
        }
    }
}


