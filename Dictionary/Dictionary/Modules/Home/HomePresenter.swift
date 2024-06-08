//
//  HomePresenter.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 8.06.2024.
//

import Foundation

protocol HomePresenterProtocol {
    func viewDidLoad()
}

final class HomePresenter {
    unowned var view: HomeViewControllerProtocol!
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

}

extension HomePresenter: HomeInteractorOutputProtocol {
    
}
