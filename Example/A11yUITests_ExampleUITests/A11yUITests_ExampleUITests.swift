//
//  A11yUITests_ExampleUITests.swift
//  A11yUITests_ExampleUITests
//
//  Created by Rob Whitaker on 05/12/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import A11yUITests

@testable import A11yUITests_Example

class A11yUITests_ExampleUITests: XCTestCase {

    override func setUp() {
        XCUIApplication().launch()
    }

    func test_allTests() {
        a11yCheckAllOnScreen()
    }

    func test_images() {
        let images = XCUIApplication().images.allElementsBoundByIndex
        a11y(tests: a11yTestSuiteImages, on: images)
    }

    func test_buttons() {
        let buttons = XCUIApplication().buttons.allElementsBoundByIndex
        a11y(tests: a11yTestSuiteInteractive, on: buttons)
    }

    func test_labels() {
        let labels = XCUIApplication().staticTexts.allElementsBoundByIndex
        a11y(tests: a11yTestSuiteLabels, on: labels)
    }

    func test_individualTest_individualButton() {
        let button = XCUIApplication().buttons["Ends with button"]
        a11yCheckValidLabelFor(button: button)
    }
}
