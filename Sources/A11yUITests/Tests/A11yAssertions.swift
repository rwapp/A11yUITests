//
//  A11yAssertions.swift
//  A11yUITests
//
//  Created by Rob Whitaker on 28/03/2021.
//

import XCTest

final class A11yAssertions {

    private var hasHeader = false
    private var duplicatedItems = [String: Set<A11yElement>]()

    func setupTests() {
        hasHeader = false
    }

    func validSizeFor(_ element: A11yElement,
                      _ minSize: Int,
                      _ file: StaticString,
                      _ line: UInt) {

        guard !element.shouldIgnore else { return }

        let minFloatSize = CGFloat(minSize)

        let heightDifference = element.frame.size.height - minFloatSize
        XCTAssertGreaterThanOrEqual(heightDifference,
                                    -A11yTestValues.floatComparisonTolerance,
                                    Failure.warning.report("Element not tall enough",
                                                           [element],
                                                           reason: "Minimum size: \(minSize)"),
                                    file: file,
                                    line: line)

        let widthDifference = element.frame.size.width - minFloatSize
        XCTAssertGreaterThanOrEqual(widthDifference,
                                    -A11yTestValues.floatComparisonTolerance,
                                    Failure.warning.report("Element not wide enough",
                                                           [element],
                                                           reason: "Minimum size: \(minSize)"),
                                    file: file,
                                    line: line)
    }

    func validLabelFor(_ element: A11yElement,
                       _ length: Int,
                       _ file: StaticString,
                       _ line: UInt) {

        guard !element.shouldIgnore,
              element.type != .cell else { return }

        if let placeholder = element.placeholder,
           placeholder.count > 0,
           element.label.count == 0 {
            XCTFail(Failure.failure.report("A placeholder is not a label",
                                           [element],
                                           reason: "No label for element with placeholder \"\(placeholder)\""),
                    file: file,
                    line: line)
        } else {

            XCTAssertGreaterThan(element.label.count,
                                 length,
                                 Failure.warning.report("Label not meaningful",
                                                        [element],
                                                        reason: "Minimum length: \(length)"),
                                 file: file,
                                 line: line)
        }
    }

    func validLabelFor(interactiveElement element: A11yElement,
                       _ length: Int,
                       _ file: StaticString,
                       _ line: UInt) {

        guard element.isControl else { return }

        // TODO: Localise this check
        XCTAssertFalse(element.label.containsCaseInsensitive("button"),
                       Failure.failure.report("Button should not contain the word button in the accessibility label",
                                              [element]),
                       file: file,
                       line: line)

        if let first = element.label.first {
            XCTAssert(first.isUppercase,
                      Failure.failure.report("Buttons should begin with a capital letter",
                                             [element]),
                      file: file,
                      line: line)
        }

        XCTAssertNil(element.label.range(of: "."),
                     Failure.failure.report("Button accessibility labels shouldn't contain punctuation",
                                            [element]),
                     file: file,
                     line: line)
    }

    func validLabelFor(image: A11yElement,
                       _ length: Int,
                       _ file: StaticString,
                       _ line: UInt) {

        guard image.type == .image else { return }

        // TODO: Localise this test
        let avoidWords = ["image", "picture", "graphic", "icon"]
        image.label.doesNotContain(avoidWords,
                                   Failure.failure.report("Images should not contain image words in the accessibility label",
                                                          [image]),
                                   file,
                                   line)

        let possibleFilenames = ["_", "-", ".png", ".jpg", ".jpeg", ".pdf", ".avci", ".heic", ".heif"]
        image.label.doesNotContain(possibleFilenames,
                                   Failure.failure.report("Image file name is used as the accessibility label",
                                                          [image]),
                                   file,
                                   line)
    }

    func validTraitFor(image: A11yElement,
                       _ file: StaticString,
                       _ line: UInt) {
        guard image.type == .image else { return }
        XCTAssert(image.traits?.contains(.image) ?? false,
                  Failure.failure.report("Image should have Image trait",
                                         [image]),
                  file: file,
                  line: line)
    }

    func validTraitFor(button: A11yElement,
                       _ file: StaticString,
                       _ line: UInt) {
        guard button.type == .button else { return }
        XCTAssert(button.traits?.contains(.button) ?? false ||
                  button.traits?.contains(.link) ?? false,
                  Failure.failure.report("Button should have Button or Link trait",
                                         [button]),
                  file: file,
                  line: line)
    }

    func conflictingTraits(_ element: A11yElement,
                           _ file: StaticString,
                           _ line: UInt) {
        guard let traits = element.traits else { return }
        XCTAssert(!traits.contains(.button) || !traits.contains(.link),
                  Failure.failure.report("Elements shouldn't have both Button and Link traits",
                                         [element]),
                  file: file,
                  line: line)

        XCTAssert(!traits.contains(.staticText) || !traits.contains(.updatesFrequently),
                  Failure.failure.report("Elements shouldn't have both Static Text and Updates Frequently traits",
                                         [element]),
                  file: file,
                  line: line)

        var interactiveTraits = UIAccessibilityTraits.none

        if traits.contains(.causesPageTurn) {
            interactiveTraits.insert(.causesPageTurn)
        }
        if traits.contains(.playsSound) {
            interactiveTraits.insert(.playsSound)
        }
        if traits.contains(.startsMediaSession) {
            interactiveTraits.insert(.startsMediaSession)
        }

        XCTAssert(traits.contains(.button) || interactiveTraits.isEmpty,
                  Failure.warning.report("Elements with \(interactiveTraits.nameString()) traits should also have a Button trait",
                                         [element]),
                  file: file,
                  line: line)
    }

    func labelLength(_ element: A11yElement,
                     _ maxLength: Int,
                     _ file: StaticString,
                     _ line: UInt) {

        guard element.type != .staticText,
              element.type != .textView,
              !element.shouldIgnore else { return }

        XCTAssertLessThanOrEqual(element.label.count,
                                 maxLength,
                                 Failure.warning.report("Label is too long",
                                                        [element],
                                                        reason: "Max length: \(maxLength)"),
                                 file: file,
                                 line: line)
    }

    func validSizeFor(interactiveElement: A11yElement,
                      allElements:  Bool,
                      _ file: StaticString,
                      _ line: UInt) {

        if (!allElements && !interactiveElement.isInteractive) ||
            !interactiveElement.isControl { return }

        let heightDifference = interactiveElement.frame.size.height - A11yTestValues.minInteractiveSize
        XCTAssertGreaterThanOrEqual(heightDifference,
                                    -A11yTestValues.floatComparisonTolerance,
                                    Failure.failure.report("Interactive element not tall enough",
                                                           [interactiveElement]),
                                    file: file,
                                    line: line)

        let widthDifference = interactiveElement.frame.size.width - A11yTestValues.minInteractiveSize
        XCTAssertGreaterThanOrEqual(widthDifference,
                                    -A11yTestValues.floatComparisonTolerance,
                                    Failure.failure.report("Interactive element not wide enough",
                                                           [interactiveElement]),
                                    file: file,
                                    line: line)
    }

    func hasHeader(_ element: A11yElement) {
        guard !hasHeader,
              element.traits?.contains(.header) ?? false else { return }
        hasHeader = true
    }

    func checkHeader(_ file: StaticString, _ line: UInt) {
        XCTAssert(hasHeader,
                  Failure.failure.report("Screen has no element with a header trait"),
                  file: file,
                  line: line)
    }

    func disabled(_ element: A11yElement,
                  _ file: StaticString,
                  _ line: UInt) {

        guard element.isControl else { return }
        XCTAssert(element.enabled,
                  Failure.warning.report("Element disabled",
                                         [element]),
                  file: file,
                  line: line)
    }

    func duplicatedLabels(_ element1: A11yElement,
                          _ element2: A11yElement) {

        guard element1.isControl,
              element2.isControl,
              element1.id != element2.id,
              element1.label.count > 0,
              element2.label.count > 0 else { return }

        if element1.label == element2.label {
            var items = duplicatedItems[element1.label] ?? Set<A11yElement>()
            items.insert(element1)
            items.insert(element2)
            duplicatedItems[element1.label] = items
        }
    }

    func checkDuplicates(_ file: StaticString,
                         _ line: UInt) {
        for duplicatePair in duplicatedItems.enumerated() {
            let element = duplicatePair.element.value
            XCTFail(Failure.warning.report("Elements have duplicated labels", Array(element)), file: file, line: line)
        }
    }
}
