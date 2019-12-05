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
        runAllA11yTestsOnScreen()
    }

    func test_images() {
        let images = XCUIApplication().images.allElementsBoundByIndex
        run(a11yTests: imageA11yTestSuite(), on: images)
    }

    func test_buttons() {
        let buttons = XCUIApplication().buttons.allElementsBoundByIndex

        run(a11yTests: interactiveA11yTestSuite(), on: buttons)
    }

    func test_labels() {
        let labels = XCUIApplication().staticTexts.allElementsBoundByIndex
        run(a11yTests: labelA11yTestSuite(), on: labels)
    }

    func test_individualTest_individualButton() {
        let button = XCUIApplication().buttons["ends with button"]
        run(a11yTests: [.buttonLabel], on: [button])
    }

}
