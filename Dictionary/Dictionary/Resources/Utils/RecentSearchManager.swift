//
//  RecentSearchManager.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 10.06.2024.
//

import Foundation

final class RecentSearchManager {
    static let shared = RecentSearchManager()
    private let userDefaults = UserDefaults.standard
    private let recentSearchKey = "recentSearchKey"
    
    private init() {}
    
    func saveSearchTerm(_ term: String) {
        var recentSearches = fetchRecentSearchTerms()
        if let index = recentSearches.firstIndex(of: term) {
            recentSearches.remove(at: index)
        }
        recentSearches.insert(term, at: 0)
        if recentSearches.count > 5 {
            recentSearches.removeLast()
        }
        userDefaults.set(recentSearches, forKey: recentSearchKey)
    }
    
    func fetchRecentSearchTerms() -> [String] {
        return userDefaults.stringArray(forKey: recentSearchKey) ?? []
    }
}
