//
//  DetailPresenter.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 9.06.2024.
//



import Foundation

protocol DetailPresenterProtocol {
    func viewDidLoad()
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
    }
}

extension DetailPresenter: DetailInteractorOutputProtocol {
    func didFetchDetails(_ details: [WordDetail]) {
        view.showDetails(details)
    }
}

