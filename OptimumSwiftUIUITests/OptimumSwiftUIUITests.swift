//
//  OptimumSwiftUIUITests.swift
//  OptimumSwiftUIUITests
//
//  Created by Jonzo Jimenez on 9/22/21.
//

import XCTest

class OptimumSwiftUIUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
                app.buttons["Sign In"].tap()
        let listButton = app.navigationBars["_TtGC7SwiftUI19UIHosting"].buttons["List"]
        listButton.tap()
        app.scrollViews.otherElements.buttons["New Employee"].tap()
        app.tables/*@START_MENU_TOKEN@*/.textFields["Email Address"]/*[[".cells[\"Email Address, Get Mail, Email Address\"].textFields[\"Email Address\"]",".textFields[\"Email Address\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["New Employee"].staticTexts["Save"].tap()
        app.alerts["Error"].children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .scrollView).element(boundBy: 1).children(matching: .other).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 2).buttons["Cancel"].tap()
        
        
        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
