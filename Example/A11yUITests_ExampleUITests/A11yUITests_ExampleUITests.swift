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

    func test_snapshotTest() {
        a11ySnapshot()
    }

    func test_allTests() {
        // Produces 20 failures

        // Accessibility Failure - Button should not contain the word 'button' in the accessibility label. Label: "Ends with button" Button.
        // Accessibility Warning - Elements have duplicated labels. Label: "Duplicated" Button, Label: "Duplicated" Button.
        // Accessibility Failure - Image file name is used as the accessibility label. Offending word: _.
        // Accessibility Failure - Images should not contain image words in the accessibility label. Offending word: image.
        // Accessibility Failure - Button accessibility labels shouldn't contain punctuation. Label: "Punctuated." Button.
        // Accessibility Failure - Buttons should begin with a capital letter. Label: " " Button.
        // Accessibility Failure - Buttons should begin with a capital letter. Label: "lowercase" Button.
        // Accessibility Warning - Element may not be tall enough. Label: "Label too small" Label. Minimum height: 14. Current height: 13.0.
        // Accessibility Warning - Element may not be wide enough. Label: "Label too small" Label. Minimum width: 14. Current width: 13.0.
        // Accessibility Failure - Interactive element not tall enough. Label: "Too Small" Button. Minimum height: 44.0. Current height: 43.0.
        // Accessibility Failure - Interactive element not wide enough. Label: "Too Small" Button. Minimum width: 44.0. Current width: 43.0.
        // Accessibility Warning - Label may be too long. Label: "A very long overly descriptive label that isn't required use context instead to infer meaning or add a hint if required" Button. Max length: 40.
        // Accessibility Warning - Label may not be meaningful. Label: " " Button. Minimum length: 2.
        // Accessibility Failure - Interactive element not tall enough. [No identifier] Text Field. Minimum height: 44.0. Current height: 34.00.
        // Accessibility Failure - Image should have Image trait. Label: "A11y_logo" Image.
        // Accessibility Failure - Screen has no element with a header trait.
        // Accessibility Failure - Button should have Button or Link trait. Label: "No trait" Button.
        // Accessibility Warning - Element disabled. Label: "Disabled" Button.
        // Accessibility Failure - Elements shouldn't have both Button and Link traits. Label: "Conflicting traits" Button.
        // Accessibility Failure - No label for element with placeholder "Placeholder". [No identifier] Text Field.

        a11yCheckAllOnScreen()
    }

    func test_images() {
        // produces 5 failures

        // Accessibility Failure - Image file name is used as the accessibility label. Offending word: _.
        // Accessibility Failure - Images should not contain image words in the accessibility label. Offending word: image.
        // Accessibility Warning - Label may not be meaningful. Label: "A11y_logo" Image. Minimum length: 10.
        // Accessibility Failure - Image should have Image trait. Label: "A11y_logo" Image.

        let images = XCUIApplication().images.allElementsBoundByIndex
        a11y(tests: a11yTestSuiteImages, on: images, minMeaningfulLength: 10)
    }

    func test_buttons() {
        // produces 13 failures

        // Accessibility Failure - Button should not contain the word 'button' in the accessibility label Label: "Ends with button" Button.
        // Accessibility Warning - Elements have duplicated labels. Label: "Duplicated" Button, Label: "Duplicated" Button.
        // Accessibility Failure - Button accessibility labels shouldn't contain punctuation Label: "Punctuated." Button.
        // Accessibility Failure - Buttons should begin with a capital letter. Label: " " Button.
        // Accessibility Failure - Buttons should begin with a capital letter. Label: "lowercase" Button.
        // Accessibility Failure - Interactive element not tall enough. Label: "Too Small" Button. Minimum height: 44.0. Current height: 43.0.
        // Accessibility Failure - Interactive element not wide enough. Label: "Too Small" Button. Minimum width: 44.0. Current width: 43.0.
        // Accessibility Warning - Label is too long. Label: "A very long overly descriptive label that isn't required use context instead to infer meaning or add a hint if required" Button. Max length: 40.
        // Accessibility Warning - Label may not be meaningful. Label: " " Button. Minimum length: 2.
        // Accessibility Failure - Button should have Button or Link trait. Label: "No trait" Button.
        // Accessibility Warning - Element disabled. Label: "Disabled" Button.
        // Accessibility Failure - Elements shouldn't have both Button and Link traits. Label: "Conflicting traits" Button.

        let buttons = XCUIApplication().buttons.allElementsBoundByIndex
        a11y(tests: a11yTestSuiteInteractive, on: buttons)
    }

    func test_labels() {
        // produces 2 failures

        // Accessibility Warning - Element not tall enough. Label: "Label too small" Label. Minimum height: 14. Current height: 13.0.
        // Accessibility Warning - Element not wide enough. Label: "Label too small" Label. Minimum width: 14. Current width: 13.0.

        let labels = XCUIApplication().staticTexts.allElementsBoundByIndex
        a11y(tests: a11yTestSuiteLabels, on: labels)
    }

    func test_individualTest_individualButton() {
        // produces 1 failure

        // Accessibility Failure - Button should not contain the word 'button' in the accessibility label. Label: "Ends with button" Button.

        let button = XCUIApplication().buttons["Ends with button"]
        a11y(tests: [.buttonLabel], on: [button])
    }
}
