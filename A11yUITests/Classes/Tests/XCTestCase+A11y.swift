//
//  XCTestCase+A11y.swift
//  A11yUITestsUITests
//
//  Created by Rob Whitaker on 05/12/2019.
//  Copyright © 2019 RWAPP. All rights reserved.
//

import XCTest

extension XCTestCase {

    private var assertions: A11yAssertions {
        A11yAssertions()
    }

    // MARK: - Test Suites

    public var a11yTestSuiteAll: [A11yTests] {
        A11yTests.allCases
    }

    public var a11yTestSuiteImages: [A11yTests] {
        [.minimumSize, .labelPresence, .imageLabel, .labelLength, .imageTrait]
    }

    public var a11yTestSuiteInteractive: [A11yTests] {
        // Valid tests for any interactive elements, eg. buttons, cells, switches, text fields etc.
        // Note: Many standard Apple controls fail these tests.

        [.minimumInteractiveSize, .labelPresence, .buttonLabel, .labelLength, .duplicated, .buttonTrait, .disabled]
    }

    public var a11yTestSuiteLabels: [A11yTests] {
        // valid for any text elements, eg. labels, text views
        [.minimumSize, .labelPresence]
    }

    // MARK: - Test Groups

    /// Run all checks on every element on screen
    public func a11yCheckAllOnScreen(file: StaticString = #file,
                                     line: UInt = #line) {

        let elements = XCUIApplication()
            .descendants(matching: .any)
            .allElementsBoundByAccessibilityElement

        a11yAllTestsOn(elements: elements,
                       file: file,
                       line: line)
    }


    /// Run all checks on the elements provided
    /// - Parameters:
    ///   - elements: Array of elements to run checks against
    ///   - minMeaningfulLength: An optional parameter to specify the minimum label length for controls. Default is 2
    public func a11yAllTestsOn(elements: [XCUIElement],
                               minMeaningfulLength length: Int = 2,
                               file: StaticString = #file,
                               line: UInt = #line) {

        a11y(tests: a11yTestSuiteAll,
             on: elements,
             minMeaningfulLength: length,
             file: file,
             line: line)
    }


    /// Run the provided tests on the provided elements
    /// - Parameters:
    ///   - tests: Array of test suites to run
    ///   - elements: Array of elements to run checks against
    ///   - minMeaningfulLength: An optional parameter to specify the minimum label length for controls. Default is 2
    public func a11y(tests: [A11yTests],
                     on elements: [XCUIElement],
                     minMeaningfulLength length: Int = 2,
                     file: StaticString = #file,
                     line: UInt = #line) {

        var a11yElements = [A11yElement]()

        for element in elements {
            a11yElements.append(A11yElement(element))
        }

        assertions.a11y(tests,
                        a11yElements,
                        length,
                        file,
                        line)

    }

    // MARK: - Individual Tests

    /// Checks element has a minimum size of 10px square
    /// - Parameters:
    ///   - element: Element to run check against
    public func a11yCheckValidSizeFor(element: XCUIElement,
                                      file: StaticString = #file,
                                      line: UInt = #line) {

        let a11yElement = A11yElement(element)

        assertions.validSizeFor(a11yElement,
                                file,
                                line)
    }


    /// Check the provided element has a label with a minimum length of `length`
    /// - Parameters:
    ///   - element: Element to run check against
    ///   - minMeaningfulLength: An optional parameter to specify the minimum label length for controls. Default is 2
    public func a11yCheckValidLabelFor(element: XCUIElement,
                                       minMeaningfulLength length: Int = 2,
                                       file: StaticString = #file,
                                       line: UInt = #line) {

        let a11yElement = A11yElement(element)

        assertions.validLabelFor(a11yElement,
                                 length,
                                 file,
                                 line)
    }


    /// Check the provided interactive element has a valid label
    /// - Parameters:
    ///   - interactiveElement: Interactive element to run check against
    ///   - minMeaningfulLength: An optional parameter to specify the minimum label length for controls. Default is 2
    public func a11yCheckValidLabelFor(interactiveElement: XCUIElement,
                                       minMeaningfulLength length: Int = 2,
                                       file: StaticString = #file,
                                       line: UInt = #line) {

        let a11yElement = A11yElement(interactiveElement)

        assertions.validLabelFor(interactiveElement: a11yElement,
                                 length,
                                 file,
                                 line)
    }


    /// Check the provided image has a valid label
    /// - Parameters:
    ///   - image: Image element to run the check against
    ///   - minMeaningfulLength: An optional parameter to specify the minimum label length for controls. Default is 2
    public func a11yCheckValidLabelFor(image: XCUIElement,
                                       minMeaningfulLength length: Int = 2,
                                       file: StaticString = #file,
                                       line: UInt = #line) {

        let a11yElement = A11yElement(image)

        assertions.validLabelFor(image: a11yElement,
                                 length,
                                 file,
                                 line)
    }


    /// Check the provided element's label is less than 40 characters
    /// - Parameters:
    ///   - element: Element to run check against
    public func a11yCheckLabelLength(element: XCUIElement,
                                     file: StaticString = #file,
                                     line: UInt = #line) {

        let a11yElement = A11yElement(element)

        assertions.labelLength(a11yElement,
                               file,
                               line)
    }


    /// Check the provided interactive element has a minimum size of 44px square
    /// - Parameters:
    ///   - interactiveElement: Interactive element to run check against
    public func a11yCheckValidSizeFor(interactiveElement: XCUIElement,
                                      file: StaticString = #file,
                                      line: UInt = #line) {

        let a11yElement = A11yElement(interactiveElement)

        assertions.validSizeFor(interactiveElement: a11yElement,
                                file,
                                line)
    }
}
