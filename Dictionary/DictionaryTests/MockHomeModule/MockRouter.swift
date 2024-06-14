//
//  MockRouter.swift
//  DictionaryTests
//
//  Created by Necati Alperen IŞIK on 14.06.2024.
//

import Foundation
@testable import Dictionary

final class MockRouter: HomeRouterProtocol {
    
    var isInvokedNavigate = false
    var invokedNavigateCount = 0
    var invokedNavigateParameters: (route: HomeRoute, Void)?
    var invokedNavigateParametersList = [(route: HomeRoute, Void)]()
    
    func navigate(to route: HomeRoute) {
        isInvokedNavigate = true
        invokedNavigateCount += 1
        invokedNavigateParameters = (route, ())
        invokedNavigateParametersList.append((route, ()))
    }
}



