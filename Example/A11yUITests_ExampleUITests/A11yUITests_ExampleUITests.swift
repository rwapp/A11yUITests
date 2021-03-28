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

class A11yUITestsExampleUITests: XCTestCase {

    override func setUp() {
        XCUIApplication().launch()
    }

    func test_allTests() {
        // Produces 17 failures

        // Accessibility Failure: Button should not contain the word button in the accessibility label, set this as an accessibility trait: "Ends with button" Button
        // Accessibility Failure: Elements have duplicated labels: "Duplicated label" Button, "Duplicated label" Button
        // Accessibility Failure: Image file name is used as the accessibility label: "A11y_logo" Image. Offending word: _
        // Accessibility Failure: Images should not contain image words in the accessibility label, set the image accessibility trait: "image of the Mobile A11y logo" Image. Offending word: image
        // Accessibility failure: Button accessibility labels shouldn't contain punctuation: "Punctuated." Button
        // Accessibility Failure: Buttons should begin with a capital letter: " " Button
        // Accessibility Failure: Buttons should begin with a capital letter: "lowercase" Button
        // Accessibility Failure: Element not tall enough: "Label too small" Label
        // Accessibility Failure: Element not wide enough: "Label too small" Label
        // Accessibility Failure: Interactive element not tall enough: "Too Small" Button
        // Accessibility Failure: Interactive element not wide enough: "Too Small" Button
        // Accessibility Failure: Label is too long: "A very long overly descriptive label that isn't required use context instead to infer meaning or add a hint if required" Button
        // Accessibility Failure: Label not meaningful: " " Button. Minimum length: 2
        // Accessibility Failure: Image should have Image trait: "A11y_logo" Image
        // Accessibility Failure: Screen has no element with a header trait
        // Accessibility Failure: Button should have Button trait: "No trait" Button
        // Accessibility Failure: Elements shouldn't have both Button and Link traits: "Conflicting traits" Button

        a11yCheckAllOnScreen()
    }

    func test_images() {
        // produces 4 failures

        // Accessibility Failure: Image file name is used as the accessibility label: "A11y_logo" Image. Offending word: _
        // Accessibility Failure: Images should not contain image words in the accessibility label, set the image accessibility trait: "image of the Mobile A11y logo" Image. Offending word: image
        // Accessibility Failure: Label not meaningful: "A11y_logo" Image. Minimum length: 10
        // Accessibility Failure: Image should have Image trait: "A11y_logo" Image

        let images = XCUIApplication().images.allElementsBoundByIndex
        a11y(tests: a11yTestSuiteImages, on: images, minMeaningfulLength: 10)
    }

    func test_buttons() {
        // produces 11 failures

        // Accessibility Failure: Button should not contain the word button in the accessibility label, set this as an accessibility trait: "Ends with button" Button
        // Accessibility Failure: Elements have duplicated labels: "Duplicated label" Button, "Duplicated label" Button
        // Accessibility failure: Button accessibility labels shouldn't contain punctuation: "Punctuated." Button
        // Accessibility Failure: Buttons should begin with a capital letter: " " Button
        // Accessibility Failure: Buttons should begin with a capital letter: "lowercase" Button
        // Accessibility Failure: Interactive element not tall enough: "Too Small" Button
        // Accessibility Failure: Interactive element not wide enough: "Too Small" Button
        // Accessibility Failure: Label is too long: "A very long overly descriptive label that isn't required use context instead to infer meaning or add a hint if required" Button
        // Accessibility Failure: Label not meaningful: " " Button. Minimum length: 2
        // Accessibility Failure: Button should have Button trait: "No trait" Button
        // Accessibility Failure: Elements shouldn't have both Button and Link traits: "Conflicting traits" Button

        let buttons = XCUIApplication().buttons.allElementsBoundByIndex
        a11y(tests: a11yTestSuiteInteractive, on: buttons)
    }

    func test_labels() {
        // produces 2 failures

        // Accessibility Failure: Element not tall enough: "Label too small" Label
        // Accessibility Failure: Element not wide enough: "Label too small" Label

        let labels = XCUIApplication().staticTexts.allElementsBoundByIndex
        a11y(tests: a11yTestSuiteLabels, on: labels)
    }

    func test_individualTest_individualButton() {
        // produces 1 failure

        // Accessibility Failure: Button should not contain the word button in the accessibility label, set this as an accessibility trait: "Ends with button" Button

        let button = XCUIApplication().buttons["Ends with button"]
        a11yCheckValidLabelFor(interactiveElement: button)
    }
}
