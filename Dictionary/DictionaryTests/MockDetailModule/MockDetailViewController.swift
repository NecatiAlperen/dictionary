//
//  MockDetailViewController.swift
//  DictionaryTests
//
//  Created by Necati Alperen IŞIK on 14.06.2024.
//

import Foundation
@testable import Dictionary

final class MockDetailViewController: DetailViewControllerProtocol {
    
    var isInvokedShowDetails = false
    var invokedShowDetailsCount = 0
    var invokedShowDetailsParameters: ([WordDetail], Void)?
    var invokedShowDetailsParametersList = [([WordDetail], Void)]()
    
    func showDetails(_ details: [WordDetail]) {
        isInvokedShowDetails = true
        invokedShowDetailsCount += 1
        invokedShowDetailsParameters = (details, ())
        invokedShowDetailsParametersList.append((details, ()))
    }
    
    var isInvokedShowSynonyms = false
    var invokedShowSynonymsCount = 0
    var invokedShowSynonymsParameters: ([Synonym], Void)?
    var invokedShowSynonymsParametersList = [([Synonym], Void)]()
    
    func showSynonyms(_ synonyms: [Synonym]) {
        isInvokedShowSynonyms = true
        invokedShowSynonymsCount += 1
        invokedShowSynonymsParameters = (synonyms, ())
        invokedShowSynonymsParametersList.append((synonyms, ()))
    }
    
    var isInvokedUpdateFilterButtons = false
    var invokedUpdateFilterButtonsCount = 0
    var invokedUpdateFilterButtonsParameters: ([String], [String])?
    var invokedUpdateFilterButtonsParametersList = [([String], [String])]()
    
    func updateFilterButtons(with titles: [String], selectedFilters: [String]) {
        isInvokedUpdateFilterButtons = true
        invokedUpdateFilterButtonsCount += 1
        invokedUpdateFilterButtonsParameters = (titles, selectedFilters)
        invokedUpdateFilterButtonsParametersList.append((titles, selectedFilters))
    }
    
    var isInvokedReloadTableView = false
    var invokedReloadTableViewCount = 0
    
    func reloadTableView() {
        isInvokedReloadTableView = true
        invokedReloadTableViewCount += 1
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
    
    var isInvokedShowPersonButton = false
    var invokedShowPersonButtonCount = 0
    var invokedShowPersonButtonParameters: (visible: Bool, Void)?
    var invokedShowPersonButtonParametersList = [(visible: Bool, Void)]()
    
    func showPersonButton(_ visible: Bool) {
        isInvokedShowPersonButton = true
        invokedShowPersonButtonCount += 1
        invokedShowPersonButtonParameters = (visible, ())
        invokedShowPersonButtonParametersList.append((visible, ()))
    }
    
    var word: String = ""
}



