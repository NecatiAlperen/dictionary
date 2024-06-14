//
//  MockDetailRouter.swift
//  DictionaryTests
//
//  Created by Necati Alperen IŞIK on 14.06.2024.
//

import Foundation
@testable import Dictionary

enum DetailRoute {
    case detail(details: [WordDetail], word: String)
}

final class MockDetailRouter: DetailRouterProtocol {
    
    var isInvokedNavigate = false
    var invokedNavigateCount = 0
    var invokedNavigateParameters: (route: DetailRoute, Void)?
    var invokedNavigateParametersList = [(route: DetailRoute, Void)]()
    
    func navigate(to route: DetailRoute) {
        isInvokedNavigate = true
        invokedNavigateCount += 1
        invokedNavigateParameters = (route, ())
        invokedNavigateParametersList.append((route, ()))
    }
    
    func presentSafariViewController(with url: URL) {
        
    }
}


