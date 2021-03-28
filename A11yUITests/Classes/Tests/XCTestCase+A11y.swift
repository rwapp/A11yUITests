//
//  XCTestCase+A11y.swift
//  A11yUITestsUITests
//
//  Created by Rob Whitaker on 05/12/2019.
//  Copyright © 2019 RWAPP. All rights reserved.
//

import XCTest

extension XCTestCase {

    public enum A11yTests: CaseIterable {
        case minimumSize,
             minimumInteractiveSize,
             labelPresence,
             buttonLabel,
             imageLabel,
             labelLength,
             duplicated,
             imageTrait
    }

    private var assertions: A11yAssertions {
        A11yAssertions()
    }

    // MARK: - Test Suites

    public var a11yTestSuiteAll: [A11yTests] {
        return A11yTests.allCases
    }

    public var a11yTestSuiteImages: [A11yTests] {
        return [.minimumSize, .labelPresence, .imageLabel, .labelLength, .imageTrait]
    }

    public var a11yTestSuiteInteractive: [A11yTests] {
        // Valid tests for any interactive elements, eg. buttons, cells, switches, text fields etc.
        // Note: Many standard Apple controls fail these tests.
        return [.minimumInteractiveSize, .labelPresence, .buttonLabel, .labelLength, .duplicated]
    }

    public var a11yTestSuiteLabels: [A11yTests] {
        // valid for any text elements, eg. labels, text views
        return [.minimumSize, .labelPresence]
    }


    // MARK: - Test Groups

    public func a11yCheckAllOnScreen(file: StaticString = #file,
                                     line: UInt = #line) {

        let elements = XCUIApplication()
            .descendants(matching: .any)
            .allElementsBoundByAccessibilityElement

        a11yAllTestsOn(elements: elements,
                       file: file,
                       line: line)
    }

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

    public func a11yCheckValidSizeFor(element: XCUIElement,
                                      file: StaticString = #file,
                                      line: UInt = #line) {

        let a11yElement = A11yElement(element)

        assertions.validSizeFor(a11yElement,
                                file,
                                line)
    }

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

    public func a11yCheckLabelLength(element: XCUIElement,
                                     file: StaticString = #file,
                                     line: UInt = #line) {

        let a11yElement = A11yElement(element)

        assertions.labelLength(a11yElement,
                               file,
                               line)
    }

    public func a11yCheckValidSizeFor(interactiveElement: XCUIElement,
                                      file: StaticString = #file,
                                      line: UInt = #line) {

        let a11yElement = A11yElement(interactiveElement)

        assertions.validSizeFor(interactiveElement: a11yElement,
                                file,
                                line)
    }

    public func a11yCheckNoDuplicatedLabels(element1: XCUIElement,
                                            element2: XCUIElement,
                                            file: StaticString = #file,
                                            line: UInt = #line) {

        let a11yElement1 = A11yElement(element1)
        let a11yElement2 = A11yElement(element2)

        assertions.duplicatedLabels(a11yElement1,
                                    a11yElement2,
                                    file,
                                    line)
    }
}