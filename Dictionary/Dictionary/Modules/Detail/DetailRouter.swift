//
//  DetailRouter.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 9.06.2024.
//

import UIKit
import SafariServices

protocol DetailRouterProtocol {
    func presentSafariViewController(with url: URL)
}

final class DetailRouter: DetailRouterProtocol {
    weak var viewController: UIViewController?

    static func createModule(with details: [WordDetail], word: String) -> DetailViewController {
        let view = DetailViewController()
        let interactor = DetailInteractor(details: details)
        let router = DetailRouter()
        let presenter = DetailPresenter(view: view, router: router, interactor: interactor)

        view.presenter = presenter
        view.word = word
        interactor.output = presenter
        router.viewController = view

        return view
    }

    func presentSafariViewController(with url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        viewController?.present(safariViewController, animated: true, completion: nil)
    }
}


