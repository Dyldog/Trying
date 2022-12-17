//
//  TryingUITests.swift
//  TryingUITests
//
//  Created by Dylan Elliott on 24/10/2022.
//

import XCTest

class TryingUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    func testScreenshots() throws {
        snapshot("01-Homescreen")
        
        app.buttons.firstMatch.tap()
        
        snapshot("02-Detail")
    }
}
