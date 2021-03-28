//
//  A11yTests.swift
//  A11yUITests
//
//  Created by Rob Whitaker on 26/03/2021.
//

import XCTest

internal extension XCTestCase {

    func a11yCheckValidSizeFor(_ element: A11yElement,
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

    func a11yCheckValidLabelFor(_ element: A11yElement,
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

    func a11yCheckValidLabelFor(interactiveElement element: A11yElement,
                                _ length: Int = 2,
                                _ file: StaticString,
                                _ line: UInt) {

        guard element.isControl else { return }

        a11yCheckValidLabelFor(element,
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

    func a11yCheckValidLabelFor(image: A11yElement,
                                _ length: Int = 2,
                                _ file: StaticString,
                                _ line: UInt) {

        guard image.type == .image else { return }

        a11yCheckValidLabelFor(image,
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

    func a11yCheckLabelLength(_ element: A11yElement,
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

    func a11yCheckValidSizeFor(interactiveElement: A11yElement,
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

    func a11yCheckNoDuplicatedLabels(_ element1: A11yElement,
                                     _ element2: A11yElement,
                                     _ file: StaticString,
                                     _ line: UInt) {

        guard element1.isControl,
              element2.isControl,
              element1.underlyingElement != element2.underlyingElement else { return }

        XCTAssertNotEqual(element1.label,
                          element2.label,
                          "Accessibility Failure: Elements have duplicated labels: \(element1.description), \(element2.description)",
                          file: file,
                          line: line)
    }

    func a11yCheckHeaderPresence(element: A11yElement) {

    }
}

private extension String {
    func containsCaseInsensitive(_ substring: String) -> Bool {
        return self.lowercased().contains(substring.lowercased())
    }

    func doesNotContain(_ words : [String],
                        _ error: String,
                        _ file: StaticString,
                        _ line: UInt) {

        for word in words {
            XCTAssertFalse(self.containsCaseInsensitive(word),
                           "\(error). Offending word: \(word)",
                           file: file,
                           line: line)
        }
    }
}

