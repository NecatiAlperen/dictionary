//
//  HomePresenterTests.swift
//  DictionaryTests
//
//  Created by Necati Alperen IŞIK on 14.06.2024.
//

import XCTest
@testable import Dictionary

final class HomePresenterTests: XCTestCase {

    private var presenter: HomePresenter!
    private var view: MockHomeViewController!
    private var interactor: MockInteractor!
    private var router: MockRouter!

    override func setUp() {
        super.setUp()
        view = MockHomeViewController()
        interactor = MockInteractor()
        router = MockRouter()
        presenter = HomePresenter(view: view, router: router, interactor: interactor)
    }

    override func tearDown() {
        view = nil
        interactor = nil
        router = nil
        presenter = nil
        super.tearDown()
    }

    func test_viewDidLoad_ShouldFetchRecentSearches() {
        presenter.viewDidLoad()
        XCTAssertFalse(interactor.isInvokedGetRecentSearches, "değer true")
    }

    func test_search_ShouldShowLoadingAndSearchWord() {
        presenter.search(query: "test")
        XCTAssertTrue(view.isInvokedShowLoading)
        XCTAssertTrue(interactor.isInvokedSearchWord)
    }

    func test_fetchRecentSearches_ShouldShowRecentSearches() {
        let searches = ["test1", "test2"]
        interactor.stubbedGetRecentSearchesResult = searches
        presenter.fetchRecentSearches()
        XCTAssertTrue(view.isInvokedShowRecentSearches)
        XCTAssertEqual(view.invokedShowRecentSearchesParameters?.searches, searches)
    }

    func test_toggleRecentSearches_ShouldToggleViewVisibility() {
        presenter.toggleRecentSearches()
        XCTAssertTrue(view.isInvokedToggleRecentSearchTableView)
    }

    func test_didFetchWordDetails_ShouldHideLoadingAndNavigateToDetail() {
        let wordDetails = [WordDetail(word: "test", phonetics: [], meanings: [], sourceUrls: [])]
        presenter.didFetchWordDetails(wordDetails)
        XCTAssertTrue(view.isInvokedHideLoading)
        XCTAssertTrue(router.isInvokedNavigate)
    }

    func test_didFailToFetchWordDetails_ShouldHideLoadingAndShowError() {
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        presenter.didFailToFetchWordDetails(with: error)
        XCTAssertTrue(view.isInvokedHideLoading)
        XCTAssertTrue(view.isInvokedShowError)
        XCTAssertEqual(view.invokedShowErrorParameters?.message, "Test error")
    }
}



