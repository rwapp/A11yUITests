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
        a11yAllTestsOn(elements: elements,
                       file: file,
                       line: line)
    }

    public func a11yAllTestsOn(elements: [XCUIElement],
                               file: StaticString = #file,
                               line: UInt = #line) {

        a11y(tests: a11yTestSuiteAll,
             on: elements,
             file: file,
             line: line)
    }

    public func a11y(tests: [A11yTests],
                     on elements: [XCUIElement],
                     file: StaticString = #file,
                     line: UInt = #line) {

        var a11yElements = [A11yElement]()

        for element in elements {
            a11yElements.append(createA11yElementFrom(element: element))
        }

        for a11yElement in a11yElements {
            if !a11yElement.shouldIgnore {

                if tests.contains(.minimumSize) {
                    a11yCheckValidSizeFor(element: a11yElement,
                                          file: file,
                                          line: line)
                }

                if tests.contains(.minimumInteractiveSize) {
                    a11yCheckValidSizeFor(interactiveElement: a11yElement,
                                          file: file,
                                          line: line)
                }

                if tests.contains(.labelPresence) {
                    a11yCheckValidLabelFor(element: a11yElement,
                                           file: file,
                                           line: line)
                }

                if tests.contains(.buttonLabel) {
                    a11yCheckValidLabelFor(interactiveElement: a11yElement,
                                           file: file,
                                           line: line)
                }

                if tests.contains(.imageLabel) {
                    a11yCheckValidLabelFor(image: a11yElement,
                                           file: file,
                                           line: line)
                }

                if tests.contains(.labelLength) {
                    a11yCheckLabelLength(element: a11yElement,
                                         file: file,
                                         line: line)
                }

                for a11yElement2 in a11yElements {
                    if tests.contains(.duplicated) {
                        a11yCheckNoDuplicatedLabels(element1: a11yElement,
                                                    element2: a11yElement2,
                                                    file: file,
                                                    line: line)
                    }
                }
            }
        }
    }


    // MARK: - Individual Tests

    public func a11yCheckValidSizeFor(element: XCUIElement,
                                      file: StaticString = #file,
                                      line: UInt = #line) {

        let a11yElement = createA11yElementFrom(element: element)

        a11yCheckValidSizeFor(element: a11yElement,
                              file: file,
                              line: line)
    }

    public func a11yCheckValidLabelFor(element: XCUIElement,
                                       file: StaticString = #file,
                                       line: UInt = #line) {

        let a11yElement = createA11yElementFrom(element: element)

        a11yCheckValidLabelFor(element: a11yElement,
                               file: file,
                               line: line)
    }

    public func a11yCheckValidLabelFor(interactiveElement: XCUIElement,
                                       file: StaticString = #file,
                                       line: UInt = #line) {

        let a11yElement = createA11yElementFrom(element: interactiveElement)

        a11yCheckValidLabelFor(interactiveElement: a11yElement,
                               file: file,
                               line: line)
    }

    public func a11yCheckValidLabelFor(image: XCUIElement,
                                       file: StaticString = #file,
                                       line: UInt = #line) {
        
        let a11yElement = createA11yElementFrom(element: image)

        a11yCheckValidLabelFor(image: a11yElement,
                               file: file,
                               line: line)
    }

    public func a11yCheckLabelLength(element: XCUIElement,
                                     file: StaticString = #file,
                                     line: UInt = #line) {

        let a11yElement = createA11yElementFrom(element: element)

        a11yCheckLabelLength(element: a11yElement,
                             file: file,
                             line: line)
    }

    public func a11yCheckValidSizeFor(interactiveElement: XCUIElement,
                                      file: StaticString = #file,
                                      line: UInt = #line) {

        let a11yElement = createA11yElementFrom(element: interactiveElement)

        a11yCheckValidSizeFor(interactiveElement: a11yElement,
                              file: file,
                              line: line)
    }

    public func a11yCheckNoDuplicatedLabels(element1: XCUIElement,
                                            element2: XCUIElement,
                                            file: StaticString = #file,
                                            line: UInt = #line) {

        let a11yElement1 = createA11yElementFrom(element: element1)
        let a11yElement2 = createA11yElementFrom(element: element2)

        a11yCheckNoDuplicatedLabels(element1: a11yElement1,
                                    element2: a11yElement2,
                                    file: file,
                                    line: line)
    }


    // MARK: - Tests

    func a11yCheckValidSizeFor(element: A11yElement,
                               file: StaticString = #file,
                               line: UInt = #line) {

        guard !element.shouldIgnore else { return }

        XCTAssert(element.frame.size.height >= 18,
                  "Accessibility Failure: Element not tall enough: \(element.description)",
                 file: file,
                 line: line)

        XCTAssert(element.frame.size.width >= 18,
                  "Accessibility Failure: Element not wide enough: \(element.description)",
                 file: file,
                 line: line)
    }

    func a11yCheckValidLabelFor(element: A11yElement,
                                file: StaticString = #file,
                                line: UInt = #line) {

        guard !element.shouldIgnore,
            element.type != .cell else { return }

        XCTAssert(element.label.count > 2,
                  "Accessibility Failure: Label not meaningful: \(element.description)",
                 file: file,
                 line: line)
    }

    func a11yCheckValidLabelFor(interactiveElement: A11yElement,
                                file: StaticString = #file,
                                line: UInt = #line) {

        guard interactiveElement.isControl else { return }

        // TODO: Localise this check
        XCTAssertFalse(interactiveElement.label.contains(substring: "button"),
                       "Accessibility Failure: Button should not contain the word button in the accessibility label. Use the button accessibility triat: \(interactiveElement.description)",
                       file: file,
                       line: line)

        XCTAssert(interactiveElement.label.first!.isUppercase, "Accessibility Failure: Button labels should begin with a capital letter: \(interactiveElement.description)",
                  file: file,
                  line: line)

        XCTAssert((interactiveElement.label.range(of: ".") == nil),
                  "Accessibility failure: Button accessibility labels shouldn't contain punctuation: \(interactiveElement.description)",
                  file: file,
                  line: line)
    }

    func a11yCheckValidLabelFor(image: A11yElement,
                                file: StaticString = #file,
                                line: UInt = #line) {

        guard image.type == .image else { return }

        // TODO: Localise this test
        let avoidWords = ["image", "picture", "graphic", "icon"]

        for word in avoidWords {
            XCTAssertFalse(image.label.contains(substring: word),
                           "Accessibility Failure: Images should not contain the word \(word) in the accessibility label. Use the image accessibility trait: \(image.description)",
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

    func a11yCheckLabelLength(element: A11yElement,
                              file: StaticString = #file,
                              line: UInt = #line) {

        guard element.type != .staticText,
            element.type != .textView,
            !element.shouldIgnore else { return }

        XCTAssertTrue(element.label.count <= 40,
                      "Accessibility Failure: Label is too long: \(element.description)",
                      file: file,
                      line: line)
    }

    func a11yCheckValidSizeFor(interactiveElement: A11yElement,
                               file: StaticString = #file,
                               line: UInt = #line) {

        guard interactiveElement.isInteractive else { return }

        XCTAssert(interactiveElement.frame.size.height >= 44,
                  "Accessibility Failure: Interactive element not tall enough: \(interactiveElement.description)",
                 file: file,
                 line: line)

        XCTAssert(interactiveElement.frame.size.width >= 44,
                  "Accessibility Failure: Interactive element not wide enough: \(interactiveElement.description)",
                  file: file,
                  line: line)
    }

    func a11yCheckNoDuplicatedLabels(element1: A11yElement,
                                     element2: A11yElement,
                                     file: StaticString = #file,
                                     line: UInt = #line) {

        guard element1.isControl,
            element2.isControl,
            element1.underlyingElement != element2.underlyingElement else { return }

        XCTAssertNotEqual(element1.label,
                          element2.label,
                       "Accessibility Failure: Elements have duplicated labels: \(element1.description), \(element2.description)",
                       file: file,
                       line: line)
    }


    // MARK: - helpers

    private func createA11yElementFrom(element: XCUIElement) -> A11yElement {
        return A11yElement(label: element.label, frame: element.frame, type: element.elementType, underlyingElement: element)
    }
}

private extension String {
    func contains(substring: String) -> Bool {
        return self.lowercased().contains(substring.lowercased())
    }
}
