//
//  DetailPresenterTests.swift
//  DictionaryTests
//
//  Created by Necati Alperen IŞIK on 14.06.2024.
//

import XCTest
@testable import Dictionary

final class DetailPresenterTests: XCTestCase {

    private var presenter: DetailPresenter!
    private var view: MockDetailViewController!
    private var interactor: MockDetailInteractor!
    private var router: MockDetailRouter!

    override func setUp() {
        super.setUp()
        view = MockDetailViewController()
        interactor = MockDetailInteractor()
        router = MockDetailRouter()
        presenter = DetailPresenter(view: view, router: router, interactor: interactor)
    }

    override func tearDown() {
        view = nil
        interactor = nil
        router = nil
        presenter = nil
        super.tearDown()
    }

    func test_viewDidLoad_ShouldFetchDetailsAndSynonyms() {
        presenter.viewDidLoad()
        XCTAssertTrue(interactor.isInvokedFetchDetails)
        XCTAssertTrue(interactor.isInvokedFetchSynonyms)
    }

    func test_loadWordDetails_ShouldFetchWordDetails() {
        presenter.loadWordDetails(for: "test")
        XCTAssertTrue(interactor.isInvokedFetchWordDetails)
    }
}








