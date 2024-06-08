//
//  SplashInteractor.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 8.06.2024.
//

import Foundation

protocol SplashInteractorProtocol {
    func checkInternetConnection()
}

protocol SplashInteractorOutputProtocol {
    func internetConnection(status: Bool)
}

final class SplashInteractor {
    var output: SplashInteractorOutputProtocol?
}

extension SplashInteractor: SplashInteractorProtocol {
    
    func checkInternetConnection() {
        let internetStatus = Reachability.isConnectedToNetwork()
        self.output?.internetConnection(status: internetStatus)
    }
    
    
}
