//
//  A11yAssertions.swift
//  A11yUITests
//
//  Created by Rob Whitaker on 28/03/2021.
//

import XCTest

class A11yAssertions {

    private var hasHeader = false

    // MARK: - Test Runner

    func a11y(_ tests: [A11yTests],
              _ elements: [A11yElement],
              _ minLength: Int,
              _ file: StaticString,
              _ line: UInt) {

        setupTests()

        for element in elements.filter( { !$0.shouldIgnore } ) {
            runTests(tests,
                     elements,
                     element,
                     minLength,
                     file,
                     line)
        }

        if tests.contains(.header) {
            checkHeader(file, line)
        }
    }

    private func runTests(_ tests: [A11yTests],
                          _ elements: [A11yElement],
                          _ element: A11yElement,
                          _ minLength: Int,
                          _ file: StaticString,
                          _ line: UInt) {

        if tests.contains(.minimumSize) {
            validSizeFor(element,
                         file,
                         line)
        }

        if tests.contains(.minimumInteractiveSize) {
            validSizeFor(interactiveElement: element,
                         file,
                         line)
        }

        if tests.contains(.labelPresence) {
            validLabelFor(element,
                          minLength,
                          file,
                          line)
        }

        if tests.contains(.buttonLabel) {
            validLabelFor(interactiveElement: element,
                          minLength,
                          file,
                          line)
        }

        if tests.contains(.imageLabel) {
            validLabelFor(image: element,
                          minLength,
                          file,
                          line)
        }

        if tests.contains(.labelLength) {
            labelLength(element,
                        file,
                        line)
        }

        if tests.contains(.imageTrait) {
            validTraitFor(image: element,
                          file,
                          line)
        }

        if tests.contains(.buttonTrait) {
            validTraitFor(button: element,
                          file,
                          line)
        }

        if tests.contains(.header) {
            hasHeader(element)
        }

        if tests.contains(.conflictingTraits) {
            conflictingTraits(element,
                              file,
                              line)
        }

        if tests.contains(.disabled) {
            disabled(element,
                     file,
                     line)
        }

        for element2 in elements {
            if tests.contains(.duplicated) {
                duplicatedLabels(element,
                                 element2,
                                 file,
                                 line)
            }
        }
    }

    private func setupTests() {
        hasHeader = false
    }

    // MARK: - Tests

    func validSizeFor(_ element: A11yElement,
                      _ file: StaticString,
                      _ line: UInt) {

        guard !element.shouldIgnore else { return }

        XCTAssertGreaterThanOrEqual(element.frame.size.height,
                                    18,
                                    "Accessibility Failure: Element not tall enough: \(element.description)",
                                    file: file,
                                    line: line)

        XCTAssertGreaterThanOrEqual(element.frame.size.width,
                                    18,
                                    "Accessibility Failure: Element not wide enough: \(element.description)",
                                    file: file,
                                    line: line)
    }

    func validLabelFor(_ element: A11yElement,
                       _ length: Int = 2,
                       _ file: StaticString,
                       _ line: UInt) {

        guard !element.shouldIgnore,
              element.type != .cell else { return }

        XCTAssertGreaterThan(element.label.count,
                             length,
                             "Accessibility Failure: Label not meaningful: \(element.description). Minimum length: \(length)",
                             file: file,
                             line: line)
    }

    func validLabelFor(interactiveElement element: A11yElement,
                       _ length: Int = 2,
                       _ file: StaticString,
                       _ line: UInt) {

        guard element.isControl else { return }

        validLabelFor(element,
                      length,
                      file,
                      line)

        // TODO: Localise this check
        XCTAssertFalse(element.label.containsCaseInsensitive("button"),
                       "Accessibility Failure: Button should not contain the word button in the accessibility label, set this as an accessibility trait: \(element.description)",
                       file: file,
                       line: line)

        if let first = element.label.first {
            XCTAssert(first.isUppercase,
                      "Accessibility Failure: Buttons should begin with a capital letter: \(element.description)",
                      file: file,
                      line: line)
        }

        XCTAssertNil(element.label.range(of: "."),
                     "Accessibility failure: Button accessibility labels shouldn't contain punctuation: \(element.description)",
                     file: file,
                     line: line)
    }

    func validLabelFor(image: A11yElement,
                       _ length: Int = 2,
                       _ file: StaticString,
                       _ line: UInt) {

        guard image.type == .image else { return }

        validLabelFor(image,
                      length,
                      file,
                      line)

        // TODO: Localise this test
        let avoidWords = ["image", "picture", "graphic", "icon"]
        image.label.doesNotContain(avoidWords,
                                   "Accessibility Failure: Images should not contain image words in the accessibility label, set the image accessibility trait: \(image.description)",
                                   file,
                                   line)

        let possibleFilenames = ["_", "-", ".png", ".jpg", ".jpeg", ".pdf", ".avci", ".heic", ".heif"]
        image.label.doesNotContain(possibleFilenames,
                                   "Accessibility Failure: Image file name is used as the accessibility label: \(image.description)",
                                   file,
                                   line)
    }

    func validTraitFor(image: A11yElement,
                       _ file: StaticString,
                       _ line: UInt) {
        guard image.type == .image else { return }
        XCTAssert(image.traits?.contains(.image) ?? false,
                  "Accessibility Failure: Image should have Image trait: \(image.description)",
                  file: file,
                  line: line)
    }

    func validTraitFor(button: A11yElement,
                       _ file: StaticString,
                       _ line: UInt) {
        guard button.type == .button else { return }
        XCTAssert(button.traits?.contains(.button) ?? false ||
                    button.traits?.contains(.link) ?? false,
                  "Accessibility Failure: Button should have Button or Link trait: \(button.description)",
                  file: file,
                  line: line)
    }

    func conflictingTraits(_ element: A11yElement,
                           _ file: StaticString,
                           _ line: UInt) {
        guard let traits = element.traits else { return }
        XCTAssert(!traits.contains(.button) || !traits.contains(.link),
                  "Accessibility Failure: Elements shouldn't have both Button and Link traits: \(element.description)",
                  file: file,
                  line: line)

        XCTAssert(!traits.contains(.staticText) || !traits.contains(.updatesFrequently),
                  "Accessibility Failure: Elements shouldn't have both Static Text and Updates Frequently traits: \(element.description)",
                  file: file,
                  line: line)
    }

    func labelLength(_ element: A11yElement,
                     _ file: StaticString,
                     _ line: UInt) {

        guard element.type != .staticText,
              element.type != .textView,
              !element.shouldIgnore else { return }

        XCTAssertLessThanOrEqual(element.label.count,
                                 40,
                                 "Accessibility Failure: Label is too long: \(element.description)",
                                 file: file,
                                 line: line)
    }

    func validSizeFor(interactiveElement: A11yElement,
                      _ file: StaticString,
                      _ line: UInt) {

        guard interactiveElement.isInteractive else { return }

        XCTAssertGreaterThanOrEqual(interactiveElement.frame.size.height,
                                    44,
                                    "Accessibility Failure: Interactive element not tall enough: \(interactiveElement.description)",
                                    file: file,
                                    line: line)

        XCTAssertGreaterThanOrEqual(interactiveElement.frame.size.width,
                                    44,
                                    "Accessibility Failure: Interactive element not wide enough: \(interactiveElement.description)",
                                    file: file,
                                    line: line)
    }

    func hasHeader(_ element: A11yElement) {
        guard !hasHeader,
              element.traits?.contains(.header) ?? false else { return }
        hasHeader = true
    }

    private func checkHeader(_ file: StaticString, _ line: UInt) {
        XCTAssert(hasHeader,
                  "Accessibility Failure: Screen has no element with a header trait",
                  file: file,
                  line: line)
    }

    func disabled(_ element: A11yElement,
                  _ file: StaticString,
                  _ line: UInt) {

        guard element.isControl else { return }
        XCTAssert(element.enabled,
                  "Accessibility Failure: Element disabled: \(element.description)",
                  file: file,
                  line: line)
    }

    func duplicatedLabels(_ element1: A11yElement,
                          _ element2: A11yElement,
                          _ file: StaticString,
                          _ line: UInt) {

        guard element1.isControl,
              element2.isControl,
              element1.id != element2.id else { return }

        XCTAssertNotEqual(element1.label,
                          element2.label,
                          "Accessibility Failure: Elements have duplicated labels: \(element1.description), \(element2.description)",
                          file: file,
                          line: line)
    }
}
