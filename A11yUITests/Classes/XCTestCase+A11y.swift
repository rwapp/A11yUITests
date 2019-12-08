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
        duplicated
    }

    // MARK: - Test Suites

    public var a11yTestSuiteAll: [A11yTests] {
        return A11yTests.allCases
    }

    public var a11yTestSuiteImages: [A11yTests] {
        return [.minimumSize, .labelPresence, .imageLabel, .labelLength]
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

        let elements = XCUIApplication().descendants(matching: .any).allElementsBoundByAccessibilityElement
        a11yAllTestsOn(elements: elements, file: file, line: line)
    }

    public func a11yAllTestsOn(elements: [XCUIElement],
                                  file: StaticString = #file,
                                  line: UInt = #line) {
        a11y(tests: a11yTestSuiteAll, on: elements, file: file, line: line)
    }

    public func a11y(tests: [A11yTests],
                    on elements: [XCUIElement],
                    file: StaticString = #file,
                    line: UInt = #line) {

        for element in elements {

            if tests.contains(.minimumSize) {
                a11yCheckValidSizeFor(element: element, file: file, line: line)
            }

            if tests.contains(.minimumInteractiveSize) {
                if element.isInteractive {
                    a11yCheckValidSizeFor(interactiveElement: element, file: file, line: line)
                }
            }

            if tests.contains(.labelPresence) {
                a11yCheckValidLabelFor(element: element, file: file, line: line)
            }

            if tests.contains(.buttonLabel) {
                a11yCheckValidLabelFor(button: element, file: file, line: line)
            }

            if tests.contains(.imageLabel) {
                a11yCheckValidLabelFor(image: element, file: file, line: line)
            }

            if tests.contains(.labelLength) {
                a11yCheckLabelLength(element: element, file: file, line: line)
            }

            for element2 in elements {
                if tests.contains(.duplicated) {
                a11yCheckNoDuplicatedLabels(element1: element,
                                            element2: element2,
                                            file: file,
                                            line: line)
                }
            }
        }
    }

    // MARK: - Individual Tests

    public func a11yCheckValidSizeFor(element: XCUIElement,
                                  file: StaticString = #file,
                                  line: UInt = #line) {

        XCTAssert(element.frame.size.height >= 18,
                  "Accessibility Failure: Element not tall enough: \(element.description)",
                 file: file,
                 line: line)

        XCTAssert(element.frame.size.width >= 18,
                  "Accessibility Failure: Element not wide enough: \(element.description)",
                 file: file,
                 line: line)
    }

    public func a11yCheckValidLabelFor(element: XCUIElement,
                                   file: StaticString = #file,
                                   line: UInt = #line) {

        guard element.isNotWindow,
            element.elementType != .other else { return }

        XCTAssert(element.label.count > 2,
                  "Accessibility Failure: Label not meaningful: \(element.description)",
                 file: file,
                 line: line)
    }

    public func a11yCheckValidLabelFor(button: XCUIElement,
                                   file: StaticString = #file,
                                   line: UInt = #line) {

        guard button.elementType == .button else { return }

        // TODO: Localise this check
        XCTAssertFalse(button.label.contains(substring: "button"),
                       "Accessibility Failure: Button should not contain the word button in the accessibility label, set this as an accessibility trait: \(button.description)",
                       file: file,
                       line: line)

        XCTAssert(button.label.first!.isUppercase, "Accessibility Failure: Buttons should begin with a capital letter: \(button.description)",
                  file: file,
                  line: line)

        XCTAssert((button.label.range(of: ".") == nil),
                  "Accessibility failure: Button accessibility labels shouldn't contain punctuation: \(button.description)",
                  file: file,
                  line: line)
    }

    public func a11yCheckValidLabelFor(image: XCUIElement,
                                   file: StaticString = #file,
                                   line: UInt = #line) {

        guard image.elementType == .image else { return }

        // TODO: Localise this test
        let avoidWords = ["image", "picture", "graphic", "icon"]

        for word in avoidWords {
            XCTAssertFalse(image.label.contains(substring: word),
                           "Accessibility Failure: Images should not contain the word \(word) in the accessibility label, set the image accessibility trait: \(image.description)",
                           file: file,
                           line: line)
        }

        let possibleFilenames = ["_", "-", ".png", ".jpg", ".jpeg", ".pdf", ".avci", ".heic", ".heif"]

        for word in possibleFilenames {
            XCTAssertFalse(image.label.contains(substring: word),
                           "Accessibility Failure: Image file name is used as the accessibility label: \(image.description)",
                           file: file,
                           line: line)
        }
    }

    public func a11yCheckLabelLength(element: XCUIElement,
                                 file: StaticString = #file,
                                 line: UInt = #line) {

        guard element.elementType != .staticText,
            element.elementType != .textView else { return }

        XCTAssertTrue(element.label.count <= 40,
                      "Accessibility Failure: Label is too long: \(element.description)",
                      file: file,
                      line: line)
    }

    public func a11yCheckValidSizeFor(interactiveElement: XCUIElement,
                                  file: StaticString = #file,
                                  line: UInt = #line) {

        XCTAssert(interactiveElement.frame.size.height >= 44,
                  "Accessibility Failure: Interactive element not tall enough: \(interactiveElement.description)",
                  file: file,
                  line: line)

        XCTAssert(interactiveElement.frame.size.width >= 44,
                  "Accessibility Failure: Interactive element not wide enough: \(interactiveElement.description)",
                  file: file,
                  line: line)
    }

    public func a11yCheckNoDuplicatedLabels(element1: XCUIElement,
                                            element2: XCUIElement,
                                            file: StaticString = #file,
                                            line: UInt = #line) {
        guard element1.isInteractive,
            element2.isInteractive,
            element1 != element2 else { return }

        XCTAssertFalse(element1.label == element2.label,
                       "Accessibility Failure: Elements have duplicated labels: \(element1.description), \(element2.description)",
                       file: file,
                       line: line)
    }
}

private extension String {
    func contains(substring: String) -> Bool {
        return self.lowercased().contains(substring.lowercased())
    }
}

private extension XCUIElement {
    var isNotWindow: Bool {
        return self.elementType != .window
    }

    var isInteractive: Bool {
        // strictly switches, steppers, sliders, segmented controls, & text fields should be included
        // but standard iOS implimentations aren't large enough.

        return self.elementType == .button ||
            self.elementType == .cell

    }
}
