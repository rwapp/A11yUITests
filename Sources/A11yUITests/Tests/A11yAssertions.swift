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

        A11yAssertGreaterThanOrEqual(heightDifference,
                                     -A11yTestValues.floatComparisonTolerance,
                                     message: "Element not tall enough",
                                     elements: [element],
                                     reason: "Minimum size: \(minSize)",
                                     severity: .warning,
                                     file: file,
                                     line: line)

        let widthDifference = element.frame.size.width - minFloatSize
        A11yAssertGreaterThanOrEqual(widthDifference,
                                     -A11yTestValues.floatComparisonTolerance,
                                     message: "Element not wide enough",
                                     elements: [element],
                                     reason: "Minimum size: \(minSize)",
                                     severity: .warning,
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

            A11yFail(message: "No label for element with placeholder \"\(placeholder)\"", elements: [element], severity: .failure, file: file, line: line)
        } else {

            A11yAssertGreaterThan(element.label.count,
                                  length,
                                  message: "Label not meaningful",
                                  elements: [element],
                                  reason: "Minimum length: \(length)",
                                  severity: .warning,
                                  file: file,
                                  line: line)
        }
    }

    func validLabelFor(interactiveElement element: A11yElement,
                       _ length: Int,
                       _ file: StaticString,
                       _ line: UInt) {

        guard element.isControl else { return }

        validLabelFor(element,
                      length,
                      file,
                      line)

        // TODO: Localise this check
        A11yAssertFalse(element.label.containsCaseInsensitive("button"),
                        message: "Button should not contain the word 'button' in the accessibility label",
                        elements: [element],
                        severity: .failure,
                        file: file,
                        line: line)

        if let first = element.label.first {
            A11yAssert(first.isUppercase,
                       message: "Buttons should begin with a capital letter",
                       elements: [element],
                       severity: .failure,
                       file: file,
                       line: line)
        }

        A11yAssertNil(element.label.range(of: "."),
                      message: "Button accessibility labels shouldn't contain punctuation",
                      elements: [element],
                      severity: .failure,
                      file: file,
                      line: line)
    }

    func validLabelFor(image: A11yElement,
                       _ length: Int,
                       _ file: StaticString,
                       _ line: UInt) {

        guard image.type == .image else { return }

        validLabelFor(image,
                      length,
                      file,
                      line)

        // TODO: Localise this test
        let avoidWords = ["image", "picture", "graphic", "icon"]

        let contained = image.label.containsWords(avoidWords)
        contained.forEach {
            A11yFail(message: "Images should not contain image words in the accessibility label", reason: "Offending word: \($0).", severity: .failure, file: file, line: line)
        }

        let possibleFilenames = ["_", "-", "png", "jpg", "jpeg", "pdf", "avci", "heic", "heif", "svg"]

        let containedFilenames = image.label.containsWords(possibleFilenames)
        containedFilenames.forEach {
            A11yFail(message: "Image file name is used as the accessibility label", reason: "Offending word: \($0).", severity: .failure, file: file, line: line)
        }
    }

    func validTraitFor(image: A11yElement,
                       _ file: StaticString,
                       _ line: UInt) {
        guard image.type == .image else { return }

        A11yAssert(image.traits?.contains(.image) ?? false,
                   message: "Image should have Image trait",
                   elements: [image],
                   severity: .failure,
                   file: file,
                   line: line)
    }

    func validTraitFor(button: A11yElement,
                       _ file: StaticString,
                       _ line: UInt) {
        guard button.type == .button else { return }

        A11yAssert(button.traits?.contains(.button) ?? false ||
                   button.traits?.contains(.link) ?? false,
                   message: "Button should have Button or Link trait",
                   elements: [button],
                   severity: .failure,
                   file: file,
                   line: line)
    }

    func conflictingTraits(_ element: A11yElement,
                           _ file: StaticString,
                           _ line: UInt) {
        guard let traits = element.traits else { return }

        A11yAssert(!traits.contains(.button) || !traits.contains(.link),
                   message: "Elements shouldn't have both Button and Link traits",
                   elements: [element],
                   severity: .failure,
                   file: file,
                   line: line)

        A11yAssert(!traits.contains(.staticText) || !traits.contains(.updatesFrequently),
                   message: "Elements shouldn't have both Static Text and Updates Frequently traits",
                   elements: [element],
                   severity: .failure,
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

        A11yAssertLessThanOrEqual(element.label.count,
                                  maxLength,
                                  message: "Label is too long",
                                  elements: [element],
                                  reason: "Max length: \(maxLength)",
                                  severity: .warning,
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

        A11yAssertGreaterThanOrEqual(heightDifference,
                                     -A11yTestValues.floatComparisonTolerance,
                                     message: "Interactive element not tall enough",
                                     elements: [interactiveElement],
                                     severity: .failure,
                                     file: file,
                                     line: line)

        let widthDifference = interactiveElement.frame.size.width - A11yTestValues.minInteractiveSize
        A11yAssertGreaterThanOrEqual(widthDifference,
                                     -A11yTestValues.floatComparisonTolerance,
                                     message: "Interactive element not wide enough",
                                     elements: [interactiveElement],
                                     severity: .failure,
                                     file: file,
                                     line: line)
    }

    func hasHeader(_ element: A11yElement) {
        guard !hasHeader,
              element.traits?.contains(.header) ?? false else { return }
        hasHeader = true
    }

    func checkHeader(_ file: StaticString, _ line: UInt) {
        A11yAssert(hasHeader,
                   message: "Screen has no element with a header trait",
                   severity: .failure,
                   file: file,
                   line: line)
    }

    func disabled(_ element: A11yElement,
                  _ file: StaticString,
                  _ line: UInt) {

        guard element.isControl else { return }

        A11yAssert(element.enabled,
                   message: "Element disabled",
                   elements: [element],
                   severity: .warning,
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
            A11yFail(message: "Elements have duplicated labels", elements: Array(element), severity: .warning, file: file, line: line)
        }
    }
}
