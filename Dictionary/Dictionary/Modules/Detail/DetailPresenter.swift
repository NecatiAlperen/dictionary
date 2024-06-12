//
//  DetailPresenter.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 9.06.2024.
//


import Foundation

protocol DetailPresenterProtocol {
    func viewDidLoad()
    func loadWordDetails(for word: String)
}

final class DetailPresenter {
    unowned var view: DetailViewControllerProtocol
    let router: DetailRouterProtocol
    let interactor: DetailInteractorProtocol

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
}

extension DetailPresenter: DetailInteractorOutputProtocol {
    func didFetchDetails(_ details: [WordDetail]) {
        view.showDetails(details)
    }

    func didFetchSynonyms(_ synonyms: [String]) {
        view.showSynonyms(synonyms)
    }

    func didFetchWordDetails(_ details: [WordDetail], synonyms: [String]) {
        view.showDetails(details)
        view.showSynonyms(synonyms)
    }
}






