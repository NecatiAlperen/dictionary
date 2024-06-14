//
//  MockInteractor.swift
//  DictionaryTests
//
//  Created by Necati Alperen IŞIK on 14.06.2024.
//

import Foundation
@testable import Dictionary

final class MockInteractor: HomeInteractorProtocol {

    var isInvokedSearchWord = false
    var invokedSearchWordCount = 0
    var invokedSearchWordParameters: (word: String, Void)?
    var invokedSearchWordParametersList = [(word: String, Void)]()

    func searchWord(_ word: String) {
        isInvokedSearchWord = true
        invokedSearchWordCount += 1
        invokedSearchWordParameters = (word, ())
        invokedSearchWordParametersList.append((word, ()))
    }

    var isInvokedSaveRecentSearch = false
    var invokedSaveRecentSearchCount = 0
    var invokedSaveRecentSearchParameters: (word: String, Void)?
    var invokedSaveRecentSearchParametersList = [(word: String, Void)]()

    func saveRecentSearch(_ word: String) {
        isInvokedSaveRecentSearch = true
        invokedSaveRecentSearchCount += 1
        invokedSaveRecentSearchParameters = (word, ())
        invokedSaveRecentSearchParametersList.append((word, ()))
    }

    var isInvokedGetRecentSearches = false
    var invokedGetRecentSearchesCount = 0
    var stubbedGetRecentSearchesResult: [String]! = []

    func getRecentSearches() -> [String] {
        isInvokedGetRecentSearches = true
        invokedGetRecentSearchesCount += 1
        return stubbedGetRecentSearchesResult
    }
}

