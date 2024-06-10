//
//  HomeRouter.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 8.06.2024.
//

import UIKit

enum HomeRoutes {
    case detail(details: [WordDetail])
}

protocol HomeRouterProtocol {
    func navigate(to route: HomeRoutes)
}

final class HomeRouter {
    weak var viewController: HomeViewController?
    
    static func createModule() -> HomeViewController {
        let view = HomeViewController()
        let interactor = HomeInteractor()
        let router = HomeRouter()
        let presenter = HomePresenter(view: view, router: router, interactor: interactor)
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        return view
    }
}

extension HomeRouter: HomeRouterProtocol {
    func navigate(to route: HomeRoutes) {
        switch route {
        case .detail(let details):
            let detailVC = DetailRouter.createModule(with: details)
            viewController?.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}


