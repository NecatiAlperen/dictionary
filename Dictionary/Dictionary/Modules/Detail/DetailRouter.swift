//
//  DetailRouter.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 9.06.2024.
//

import UIKit

enum DetailRoutes {
    case home
}

protocol DetailRouterProtocol {
    func navigate(_ route: DetailRoutes)
}

final class DetailRouter {
    weak var viewController: DetailViewController?
    
    static func createModule(with details: [WordDetail]) -> DetailViewController {
        let view = DetailViewController()
        let interactor = DetailInteractor(details: details)
        let router = DetailRouter()
        let presenter = DetailPresenter(view: view, router: router, interactor: interactor)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        return view
    }
}

extension DetailRouter: DetailRouterProtocol {
    func navigate(_ route: DetailRoutes) {
        // todo? sourceurls webview
    }
}


