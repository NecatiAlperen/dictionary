//
//  SplashPresenter.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 8.06.2024.
//

import Foundation

protocol SplashPresenterProtocol {
    func viewDidAppear()
}

final class SplashPresenter: SplashPresenterProtocol {
    
    unowned var view: SplashViewControllerProtocol!
    let router: SplashRouterProtocol!
    let interactor: SplashInteractorProtocol!
    
    init(
        view: SplashViewControllerProtocol,
        router: SplashRouterProtocol,
        interactor: SplashInteractorProtocol!
    ) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    func viewDidAppear() {
        interactor.checkInternetConnection()
    }
}

extension SplashPresenter: SplashInteractorOutputProtocol {
    
    func internetConnection(status: Bool) {
        if status {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.router.navigate(.home)
            }
        } else {
            DispatchQueue.main.async {
                self.view.noInternetConnection()
            }
        }
    }
}
