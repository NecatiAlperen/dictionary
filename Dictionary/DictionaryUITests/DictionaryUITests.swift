//
//  DictionaryUITests.swift
//  DictionaryUITests
//
//  Created by Necati Alperen IŞIK on 8.06.2024.
//

import XCTest

final class DictionaryUITests: XCTestCase {

    private var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func navigateHome() {
        sleep(4)
    }
    
    func test_exists_element() {
        navigateHome()
        XCTAssertTrue(app.isSearchButtonDisplayed, "Search button is not displayed")
    }
    
    func test_searchButton_isEnabled() {
        navigateHome()
        XCTAssertTrue(app.searchButton.isEnabled, "Search button is not enabled")
    }
    
    func test_searchButton_tap() {
        navigateHome()
        let searchButton = app.searchButton
        XCTAssertTrue(searchButton.exists, "Search button does not exist")
        searchButton.tap()
    }
    
}
    
extension XCUIApplication {
    
    
    var searchButton: XCUIElement {
        buttons["searchButton"]
    }
    
    var isSearchButtonDisplayed: Bool {
        searchButton.exists
    }
}



