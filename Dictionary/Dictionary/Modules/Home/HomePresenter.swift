//
//  HomePresenter.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 8.06.2024.
//

import Foundation

protocol HomePresenterProtocol {
    func viewDidLoad()
    func search(query: String)
    func fetchRecentSearches()
    func numberOfRecentSearches() -> Int
    func recentSearch(at index: Int) -> String
    func selectRecentSearch(at index: Int)
    func toggleRecentSearches()
}

final class HomePresenter {
    unowned var view: HomeViewControllerProtocol
    let router: HomeRouterProtocol
    let interactor: HomeInteractorProtocol
    private var recentSearches: [String] = []
    private var isRecentSearchesVisible: Bool = false

    init(view: HomeViewControllerProtocol, router: HomeRouterProtocol, interactor: HomeInteractorProtocol) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}

extension HomePresenter: HomePresenterProtocol {
    func viewDidLoad() {
        fetchRecentSearches()
    }

    func search(query: String) {
        view.showLoadingView()
        interactor.searchWord(query)
    }

    func fetchRecentSearches() {
        recentSearches = interactor.getRecentSearches()
        view.showRecentSearches(recentSearches)
        if isRecentSearchesVisible {
            view.toggleRecentSearchTableView(isVisible: isRecentSearchesVisible)
        }
    }
    
    func numberOfRecentSearches() -> Int {
        return recentSearches.count
    }
    
    func recentSearch(at index: Int) -> String {
        return recentSearches[index]
    }
    
    func selectRecentSearch(at index: Int) {
        let searchText = recentSearches[index]
        search(query: searchText)
    }
    
    func toggleRecentSearches() {
        isRecentSearchesVisible.toggle()
        view.toggleRecentSearchTableView(isVisible: isRecentSearchesVisible)
        if isRecentSearchesVisible {
            fetchRecentSearches()
        }
    }
}

extension HomePresenter: HomeInteractorOutputProtocol {
    func didFetchWordDetails(_ details: [WordDetail]) {
        view.hideLoadingView()
        router.navigate(to: .detail(details: details, word: details.first?.word ?? ""))
        fetchRecentSearches()
    }

    func didFailToFetchWordDetails(with error: Error) {
        view.hideLoadingView()
        view.showError(error.localizedDescription)
    }
}


