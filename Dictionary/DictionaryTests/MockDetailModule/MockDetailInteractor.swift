//
//  MockDetailınteractor.swift
//  DictionaryTests
//
//  Created by Necati Alperen IŞIK on 14.06.2024.
//

import Foundation
@testable import Dictionary

final class MockDetailInteractor: DetailInteractorProtocol {
    
    var isInvokedFetchDetails = false
    var invokedFetchDetailsCount = 0
    
    func fetchDetails() {
        isInvokedFetchDetails = true
        invokedFetchDetailsCount += 1
    }
    
    var isInvokedFetchSynonyms = false
    var invokedFetchSynonymsCount = 0
    var invokedFetchSynonymsParameters: (word: String, Void)?
    var invokedFetchSynonymsParametersList = [(word: String, Void)]()
    
    func fetchSynonyms(for word: String) {
        isInvokedFetchSynonyms = true
        invokedFetchSynonymsCount += 1
        invokedFetchSynonymsParameters = (word, ())
        invokedFetchSynonymsParametersList.append((word, ()))
    }
    
    var isInvokedFetchWordDetails = false
    var invokedFetchWordDetailsCount = 0
    var invokedFetchWordDetailsParameters: (word: String, Void)?
    var invokedFetchWordDetailsParametersList = [(word: String, Void)]()
    
    func fetchWordDetails(for word: String) {
        isInvokedFetchWordDetails = true
        invokedFetchWordDetailsCount += 1
        invokedFetchWordDetailsParameters = (word, ())
        invokedFetchWordDetailsParametersList.append((word, ()))
    }
}



