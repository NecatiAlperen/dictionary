//
//  MockHomeViewController.swift
//  DictionaryTests
//
//  Created by Necati Alperen IŞIK on 14.06.2024.
//

import Foundation
@testable import Dictionary

final class MockHomeViewController: HomeViewControllerProtocol {

    var isInvokedShowLoading = false
    var invokedShowLoadingCount = 0

    func showLoadingView() {
        isInvokedShowLoading = true
        invokedShowLoadingCount += 1
    }

    var isInvokedHideLoading = false
    var invokedHideLoadingCount = 0

    func hideLoadingView() {
        isInvokedHideLoading = true
        invokedHideLoadingCount += 1
    }

    var isInvokedShowError = false
    var invokedShowErrorCount = 0
    var invokedShowErrorParameters: (message: String, Void)?
    var invokedShowErrorParametersList = [(message: String, Void)]()

    func showError(_ message: String) {
        isInvokedShowError = true
        invokedShowErrorCount += 1
        invokedShowErrorParameters = (message, ())
        invokedShowErrorParametersList.append((message, ()))
    }

    var isInvokedShowRecentSearches = false
    var invokedShowRecentSearchesCount = 0
    var invokedShowRecentSearchesParameters: (searches: [String], Void)?
    var invokedShowRecentSearchesParametersList = [(searches: [String], Void)]()

    func showRecentSearches(_ searches: [String]) {
        isInvokedShowRecentSearches = true
        invokedShowRecentSearchesCount += 1
        invokedShowRecentSearchesParameters = (searches, ())
        invokedShowRecentSearchesParametersList.append((searches, ()))
    }

    var isInvokedToggleRecentSearchTableView = false
    var invokedToggleRecentSearchTableViewCount = 0
    var invokedToggleRecentSearchTableViewParameters: (isVisible: Bool, Void)?
    var invokedToggleRecentSearchTableViewParametersList = [(isVisible: Bool, Void)]()

    func toggleRecentSearchTableView(isVisible: Bool) {
        isInvokedToggleRecentSearchTableView = true
        invokedToggleRecentSearchTableViewCount += 1
        invokedToggleRecentSearchTableViewParameters = (isVisible, ())
        invokedToggleRecentSearchTableViewParametersList.append((isVisible, ()))
    }
}

