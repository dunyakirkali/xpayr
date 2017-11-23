//
//  xpayrUITests.swift
//  xpayrUITests
//
//  Created by Dunya Kirkali on 11/23/17.
//  Copyright © 2017 Ahtung Ltd. Sti. All rights reserved.
//

import XCTest

class xpayrUITests: XCTestCase {
    
    let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        app.launchArguments = ["--reset"]
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSuccessfullyCreateAnItem() {
        createItem()
        
        XCTAssertTrue(app.tables/*@START_MENU_TOKEN@*/.staticTexts["Test Item"]/*[[".cells.staticTexts[\"Test Item\"]",".staticTexts[\"Test Item\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
    }
    
    func testSuccessfullyDeleteAnItem() {
        createItem()
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.cells.containing(.staticText, identifier:"Test Item").element.swipeLeft()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Delete"]/*[[".cells.buttons[\"Delete\"]",".buttons[\"Delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.sheets.buttons["OK"].tap()

        XCTAssertFalse(app.tables/*@START_MENU_TOKEN@*/.staticTexts["Test Item"]/*[[".cells.staticTexts[\"Test Item\"]",".staticTexts[\"Test Item\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
    }
    
    func testSuccessfullyUpdateAnItem() {
        createItem()
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Test Item"]/*[[".cells.staticTexts[\"Test Item\"]",".staticTexts[\"Test Item\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let textField = app.otherElements.containing(.navigationBar, identifier:"xpayr.CreationView").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .textField).element
        textField.tap()
        textField.typeText("s")
        app.toolbars.buttons["Toolbar Done Button"].tap()
        app.buttons["Save"].tap()
        
        XCTAssertTrue(tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Test Items"]/*[[".cells.staticTexts[\"Test Items\"]",".staticTexts[\"Test Items\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
    }
    
    func createItem() {
        app.navigationBars["Items"].buttons["Add"].tap()
        let textField = app.otherElements.containing(.navigationBar, identifier:"xpayr.CreationView").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .textField).element
        textField.tap()
        textField.typeText("Test Item")
        app.toolbars.buttons["Toolbar Done Button"].tap()
        app.buttons["Save"].tap()
    }
}
