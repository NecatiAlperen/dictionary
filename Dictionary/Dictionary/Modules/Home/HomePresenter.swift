//
//  HomePresenter.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 8.06.2024.
//

import Foundation

import Foundation

protocol HomePresenterProtocol {
    func viewDidLoad()
    func search(query: String)
}

final class HomePresenter {
    unowned var view: HomeViewControllerProtocol
    let router: HomeRouterProtocol
    let interactor: HomeInteractorProtocol

    init(
        view: HomeViewControllerProtocol,
        router: HomeRouterProtocol,
        interactor: HomeInteractorProtocol
    ) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}

extension HomePresenter: HomePresenterProtocol {
    func viewDidLoad() {
        print("home view did load")
    }

    func search(query: String) {
        view.showLoadingView()
        interactor.searchWord(query)
    }
}

extension HomePresenter: HomeInteractorOutputProtocol {
    func didFetchWordDetails(_ details: [WordDetail]) {
        view.hideLoadingView()
        router.navigate(to: .detail(details: details))
    }

    func didFailToFetchWordDetails(with error: Error) {
        view.hideLoadingView()
        view.showError(error.localizedDescription)
    }
}
