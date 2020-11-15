//
//  WeatherTestUITests.swift
//  WeatherTestUITests
//
//  Created by Pattarapol Sawasdee on 13/11/2563 BE.
//

import XCTest

class WeatherTestUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testMain() throws {
        let app = XCUIApplication()
        app.launch()
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText("bangkok")
        app.firstMatch.tap()
    }
    
    func testMainInCaseError() throws {
        let app = XCUIApplication()
        app.launch()
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText("xxxxxx")
        app.firstMatch.tap()
        XCTAssertEqual("Error: status 404", app.staticTexts.element(boundBy: 1).label)
    }
    
    func testMainChangeTempType() throws {
        let app = XCUIApplication()
        app.launch()
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText("bangkok")
        app.firstMatch.tap()
        app.buttons.element(boundBy: 1).tap()
    }
    
    func testForecast() throws {
        let app = XCUIApplication()
        app.launch()
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText("bangkok")
        app.firstMatch.tap()
        app.navigationBars.children(matching: .button).firstMatch.tap()
        app.tables.firstMatch.swipeUp()
    }
    
}
