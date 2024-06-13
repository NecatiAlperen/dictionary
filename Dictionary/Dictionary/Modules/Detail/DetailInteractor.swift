//
//  DetailInteractor.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 9.06.2024.
//

import Foundation

protocol DetailInteractorProtocol {
    func fetchDetails()
    func fetchSynonyms(for word: String)
    func fetchWordDetails(for word: String)
}

protocol DetailInteractorOutputProtocol: AnyObject {
    func didFetchDetails(_ details: [WordDetail])
    func didFetchSynonyms(_ synonyms: [String])
    func didFetchWordDetails(_ details: [WordDetail], synonyms: [String])
}

final class DetailInteractor {
    weak var output: DetailInteractorOutputProtocol?
    private var details: [WordDetail]?
    
    init(details: [WordDetail]?) {
        self.details = details
    }
}

extension DetailInteractor: DetailInteractorProtocol {
    func fetchDetails() {
        if let details = details {
            output?.didFetchDetails(details)
        }
    }
    
    func fetchSynonyms(for word: String) {
        NetworkService.shared.fetchSynonyms(word: word) { [weak self] result in
            switch result {
            case .success(let synonyms):
                self?.output?.didFetchSynonyms(synonyms)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchWordDetails(for word: String) {
        let group = DispatchGroup()
        var fetchedDetails: [WordDetail] = []
        var fetchedSynonyms: [String] = []
        
        group.enter()
        NetworkService.shared.fetchWordDetails(word: word) { result in
            if case .success(let details) = result {
                fetchedDetails = details
            }
            group.leave()
        }
        
        group.enter()
        NetworkService.shared.fetchSynonyms(word: word) { result in
            if case .success(let synonyms) = result {
                fetchedSynonyms = synonyms
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.output?.didFetchWordDetails(fetchedDetails, synonyms: fetchedSynonyms)
        }
    }
}


