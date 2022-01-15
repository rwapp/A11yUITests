//
//  XCTestCase+A11y.swift
//  A11yUITestsUITests
//
//  Created by Rob Whitaker on 05/12/2019.
//  Copyright © 2019 RWAPP. All rights reserved.
//

import XCTest

extension XCTestCase {

    private var testRunner: TestRunner {
        TestRunner()
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

        [.minimumInteractiveSize, .labelPresence, .buttonLabel, .labelLength, .duplicated, .buttonTrait, .disabled, .conflictingTraits]
    }

    public var a11yTestSuiteLabels: [A11yTests] {
        // valid for any text elements, eg. labels, text views
        [.minimumSize, .labelPresence, .conflictingTraits]
    }

    // MARK: - Test Groups

    /// Run all checks on every element on screen
    public func a11yCheckAllOnScreen(file: StaticString = #file,
                                     line: UInt = #line,
                                     ignoringElementIdentifiers: [String] = [String]()) {

        let elements = XCUIApplication()
            .descendants(matching: .any)
            .allElementsBoundByAccessibilityElement
            .filter ({
                !ignoringElementIdentifiers.contains($0.identifier)
            })

        a11yAllTestsOn(elements: elements,
                       file: file,
                       line: line)
    }


    /// Run all checks on the elements provided
    /// - Parameters:
    ///   - elements: Array of elements to run checks against
    ///   - minMeaningfulLength: An optional parameter to specify the minimum label length for controls. Default is 2
    public func a11yAllTestsOn(elements: [XCUIElement],
                               minMeaningfulLength length: Int = A11yValues.minMeaningfulLength,
                               maxMeaningfulLength maxLength: Int = A11yValues.maxMeaningfulLength,
                               minSize: Int = A11yValues.minSize,
                               allInteractiveElements: Bool = A11yValues.allInteractiveElements,
                               file: StaticString = #file,
                               line: UInt = #line) {

        a11y(tests: a11yTestSuiteAll,
             on: elements,
             minMeaningfulLength: length,
             maxMeaningfulLength: maxLength,
             allInteractiveElements: allInteractiveElements,
             file: file,
             line: line)
    }


    /// Run the provided tests on the provided elements
    /// - Parameters:
    ///   - tests: Array of test suites to run
    ///   - elements: Array of elements to run checks against
    ///   - minMeaningfulLength: An optional parameter to specify the minimum label length for controls. Default is 2
    ///   - maxMeaningfulLength: An optional parameter to specify the maximum label length for controls. Default is 40
    ///   - minSize: An optional parameter to specify the minimum size for elements. Default is 14
    ///   - allInteractiveElements: An optional parameter to run interactive element size check on all interactive elements. Default is true
    public func a11y(tests: [A11yTests],
                     on elements: [XCUIElement],
                     minMeaningfulLength minLength: Int = A11yValues.minMeaningfulLength,
                     maxMeaningfulLength maxLength: Int = A11yValues.maxMeaningfulLength,
                     minSize: Int = A11yValues.minSize,
                     allInteractiveElements: Bool = A11yValues.allInteractiveElements,
                     file: StaticString = #file,
                     line: UInt = #line) {

        let a11yElements = elements.map { A11yElement($0) }
        testRunner.a11y(tests,
                        a11yElements,
                        minLength,
                        maxLength,
                        minSize,
                        allInteractiveElements,
                        file,
                        line)

    }

    // MARK: - Individual Tests

    /// Checks element has a minimum size
    /// - Parameters:
    ///   - element: Element to run check against
    ///   - minSize: An optional parameter to specify the minimum size for the element. Default is 14
    public func a11yCheckValidSizeFor(element: XCUIElement,
                                      minSize: Int = A11yValues.minSize,
                                      file: StaticString = #file,
                                      line: UInt = #line) {

        let a11yElement = A11yElement(element)

        testRunner.assertions.validSizeFor(a11yElement,
                                           minSize,
                                           file,
                                           line)
    }


    /// Check the provided element has a label with a minimum length of `length`
    /// - Parameters:
    ///   - element: Element to run check against
    ///   - minMeaningfulLength: An optional parameter to specify the minimum label length for controls. Default is 2
    public func a11yCheckValidLabelFor(element: XCUIElement,
                                       minMeaningfulLength length: Int = A11yValues.minMeaningfulLength,
                                       file: StaticString = #file,
                                       line: UInt = #line) {

        let a11yElement = A11yElement(element)

        testRunner.assertions.validLabelFor(a11yElement,
                                            length,
                                            file,
                                            line)
    }


    /// Check the provided interactive element has a valid label
    /// - Parameters:
    ///   - interactiveElement: Interactive element to run check against
    ///   - minMeaningfulLength: An optional parameter to specify the minimum label length for controls. Default is 2
    public func a11yCheckValidLabelFor(interactiveElement: XCUIElement,
                                       minMeaningfulLength length: Int = A11yValues.minMeaningfulLength,
                                       file: StaticString = #file,
                                       line: UInt = #line) {

        let a11yElement = A11yElement(interactiveElement)

        testRunner.assertions.validLabelFor(interactiveElement: a11yElement,
                                            length,
                                            file,
                                            line)
    }


    /// Check the provided image has a valid label
    /// - Parameters:
    ///   - image: Image element to run the check against
    ///   - minMeaningfulLength: An optional parameter to specify the minimum label length for controls. Default is 2
    public func a11yCheckValidLabelFor(image: XCUIElement,
                                       minMeaningfulLength length: Int = A11yValues.minMeaningfulLength,
                                       file: StaticString = #file,
                                       line: UInt = #line) {

        let a11yElement = A11yElement(image)

        testRunner.assertions.validLabelFor(image: a11yElement,
                                            length,
                                            file,
                                            line)
    }


    /// Check the provided element's label is less than the provided number of characters
    /// - Parameters:
    ///   - element: Element to run check against
    ///   - maxLength: An optional parameter to specify the maximum label length for controls. Default is 40
    public func a11yCheckLabelLength(element: XCUIElement,
                                     maxLength: Int = A11yValues.maxMeaningfulLength,
                                     file: StaticString = #file,
                                     line: UInt = #line) {

        let a11yElement = A11yElement(element)

        testRunner.assertions.labelLength(a11yElement,
                                          maxLength,
                                          file,
                                          line)
    }


    /// Check the provided interactive element has a minimum size of 44px square
    /// - Parameters:
    ///   - interactiveElement: Interactive element to run check against
    ///   - allElements: An optional parameter to run interactive element size check on all interactive elements. Default is true
    public func a11yCheckValidSizeFor(interactiveElement: XCUIElement,
                                      allElements: Bool = A11yValues.allInteractiveElements,
                                      file: StaticString = #file,
                                      line: UInt = #line) {

        let a11yElement = A11yElement(interactiveElement)

        testRunner.assertions.validSizeFor(interactiveElement: a11yElement,
                                           allElements: allElements,
                                           file,
                                           line)
    }
}
