//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Виктор on 04.05.2023.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }

    func testYesButton() throws {
        sleep(3)
        let firstPoster = app.images["Poster"].screenshot().pngRepresentation
        app.buttons["Yes"].tap()
        sleep(3)
        let secondPoster = app.images["Poster"].screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPoster, secondPoster)
    }
    
    func testNoButton() throws {
        sleep(3)
        let firstPoster = app.images["Poster"].screenshot().pngRepresentation
        app.buttons["No"].tap()
        sleep(3)
        let secondPoster = app.images["Poster"].screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPoster, secondPoster)
    }
    func testEndAlertShowing() throws {
        sleep(2)
        for _ in 0...9 {
            app.buttons["Yes"].tap()
            sleep(2)
        }
        let alert = app.alerts["EndAlert"]
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Cыграть еще раз")
    }
}
