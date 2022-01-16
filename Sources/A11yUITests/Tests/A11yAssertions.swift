//
//  A11yAssertions.swift
//  A11yUITests
//
//  Created by Rob Whitaker on 28/03/2021.
//

import XCTest

class A11yAssertions {

    private var hasHeader = false

    func setupTests() {
        hasHeader = false
    }

    func validSizeFor(_ element: A11yElement,
                      _ minSize: Int,
                      _ file: StaticString,
                      _ line: UInt) {

        guard !element.shouldIgnore else { return }

        let minFloatSize = CGFloat(minSize)

        XCTAssertGreaterThanOrEqual(element.frame.size.height,
                                    minFloatSize,
                                    failureMessage("Element not tall enough",
                                                   .warning,
                                                   element,
                                                   reason: "Minimum size: \(minSize)"),
                                    file: file,
                                    line: line)

        XCTAssertGreaterThanOrEqual(element.frame.size.width,
                                    minFloatSize,
                                    failureMessage("Element not wide enough",
                                                   .warning,
                                                   element,
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

        XCTAssertGreaterThan(element.label.count,
                             length,
                             failureMessage("Label not meaningful",
                                            .warning,
                                            element,
                                            reason: "Minimum length: \(length)"),
                             file: file,
                             line: line)
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
        XCTAssertFalse(element.label.containsCaseInsensitive("button"),
                       failureMessage("Button should not contain the word button in the accessibility label",
                                      .failure,
                                      element),
                       file: file,
                       line: line)

        if let first = element.label.first {
            XCTAssert(first.isUppercase,
                      failureMessage("Buttons should begin with a capital letter",
                                     .failure,
                                     element),
                      file: file,
                      line: line)
        }

        XCTAssertNil(element.label.range(of: "."),
                     failureMessage("Button accessibility labels shouldn't contain punctuation",
                                    .failure,
                                    element),
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
        image.label.doesNotContain(avoidWords,
                                   failureMessage("Images should not contain image words in the accessibility label",
                                                  .failure,
                                                  image),
                                   file,
                                   line)

        let possibleFilenames = ["_", "-", ".png", ".jpg", ".jpeg", ".pdf", ".avci", ".heic", ".heif"]
        image.label.doesNotContain(possibleFilenames,
                                   failureMessage("Image file name is used as the accessibility label",
                                                  .failure,
                                                  image),
                                   file,
                                   line)
    }

    func validTraitFor(image: A11yElement,
                       _ file: StaticString,
                       _ line: UInt) {
        guard image.type == .image else { return }
        XCTAssert(image.traits?.contains(.image) ?? false,
                  failureMessage("Image should have Image trait",
                                 .failure,
                                 image),
                  file: file,
                  line: line)
    }

    func validTraitFor(button: A11yElement,
                       _ file: StaticString,
                       _ line: UInt) {
        guard button.type == .button else { return }
        XCTAssert(button.traits?.contains(.button) ?? false ||
                  button.traits?.contains(.link) ?? false,
                  failureMessage("Button should have Button or Link trait",
                                 .failure,
                                 button),
                  file: file,
                  line: line)
    }

    func conflictingTraits(_ element: A11yElement,
                           _ file: StaticString,
                           _ line: UInt) {
        guard let traits = element.traits else { return }
        XCTAssert(!traits.contains(.button) || !traits.contains(.link),
                  failureMessage("Elements shouldn't have both Button and Link traits",
                                 .failure,
                                 element),
                  file: file,
                  line: line)

        XCTAssert(!traits.contains(.staticText) || !traits.contains(.updatesFrequently),
                  failureMessage("Elements shouldn't have both Static Text and Updates Frequently traits",
                                 .failure,
                                 element),
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
                       failureMessage("Elements with \(interactiveTraits.name()) traits should also have a Button trait",
                                      .warning,
                                      element),
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
                                 failureMessage("Label is too long",
                                                .warning,
                                                element,
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

        XCTAssertGreaterThanOrEqual(interactiveElement.frame.size.height,
                                    A11yValues.minInteractiveSize,
                                    failureMessage("Interactive element not tall enough",
                                                   .failure,
                                                   interactiveElement),
                                    file: file,
                                    line: line)

        XCTAssertGreaterThanOrEqual(interactiveElement.frame.size.width,
                                    A11yValues.minInteractiveSize,
                                    failureMessage("Interactive element not wide enough",
                                                   .failure,
                                                   interactiveElement),
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
                  failureMessage("Screen has no element with a header trait",
                                 .failure),
                  file: file,
                  line: line)
    }

    func disabled(_ element: A11yElement,
                  _ file: StaticString,
                  _ line: UInt) {

        guard element.isControl else { return }
        XCTAssert(element.enabled,
                  failureMessage("Element disabled",
                                 .warning,
                                 element),
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
                          failureMessage("Elements have duplicated labels",
                                         .warning,
                                         element1,
                                         element2),
                          file: file,
                          line: line)
    }

    private enum FailureType: String {
        case failure, warning
    }

    private func failureMessage(_ message: String,
                                _ type: FailureType,
                                _ element1: A11yElement? = nil,
                                _ element2: A11yElement? = nil,
                                reason: String? = nil
    ) -> String {

        var reasonMessage = ""
        if let reason = reason {
            reasonMessage = " \(reason)."
        }

        var elementMessage = "."
        if let element1 = element1 {
            if let element2 = element2 {
                elementMessage = ": \(element1.description), \(element2.description)."
            } else {
                elementMessage = ": \(element1.description)."
            }
        }

        let prefix = type == .warning ? "⚠️" : "❌"

        return "\(prefix) Accessibility \(type.rawValue.capitalized): \(message)\(elementMessage)\(reasonMessage)"
    }
}
