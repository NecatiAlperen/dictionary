//
//  DetailInteractor.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 9.06.2024.
//

import Foundation

protocol DetailInteractorProtocol {
    func fetchDetails()
}

protocol DetailInteractorOutputProtocol: AnyObject {
    func didFetchDetails(_ details: [WordDetail])
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
}
