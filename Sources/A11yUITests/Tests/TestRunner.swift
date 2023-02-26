//
//  TestRunner.swift
//  A11yUITests
//
//  Created by Rob Whitaker on 19/04/2021.
//

import Foundation


final class TestRunner {

    let assertions = A11yAssertions()

    func a11y(_ tests: [A11yTests],
              _ elements: [A11yElement],
              _ minLength: Int,
              _ maxLength: Int,
              _ minSize: Int,
              _ allInteractiveElements: Bool,
              _ file: StaticString,
              _ line: UInt) {

        assertions.setupTests()

        for element in elements.filter( { !$0.shouldIgnore } ) {
            runTests(tests,
                     elements,
                     element,
                     minLength,
                     maxLength,
                     minSize,
                     allInteractiveElements,
                     file,
                     line)
        }

        if tests.contains(.header) {
            assertions.checkHeader(file, line)
        }

        if tests.contains(.duplicated) {
            assertions.checkDuplicates(file, line)
        }

        if tests.contains(.controlSpacing) || tests.contains(.controlOverlap) {
            assertions.checkControlSpacing(file, line)
        }
    }

    private func runTests(_ tests: [A11yTests],
                          _ elements: [A11yElement],
                          _ element: A11yElement,
                          _ minLength: Int,
                          _ maxLength: Int,
                          _ minSize: Int,
                          _ allInteractiveElements: Bool,
                          _ file: StaticString,
                          _ line: UInt) {

        var tests = tests
        if tests.contains(.buttonLabel) || tests.contains(.imageLabel) {
            tests.append(.labelPresence)
        }

        if tests.contains(.minimumSize) {
            assertions.validSizeFor(element,
                                    minSize,
                                    file,
                                    line)
        }

        if tests.contains(.minimumInteractiveSize) {
            assertions.validSizeFor(interactiveElement: element,
                                    allElements: allInteractiveElements,
                                    file,
                                    line)
        }

        if tests.contains(.labelPresence) {
            assertions.validLabelFor(element,
                                     minLength,
                                     file,
                                     line)
        }

        if tests.contains(.buttonLabel) {
            assertions.validLabelFor(interactiveElement: element,
                                     minLength,
                                     file,
                                     line)
        }

        if tests.contains(.imageLabel) {
            assertions.validLabelFor(image: element,
                                     minLength,
                                     file,
                                     line)
        }

        if tests.contains(.labelLength) {
            assertions.labelLength(element,
                                   maxLength,
                                   file,
                                   line)
        }

        if tests.contains(.imageTrait) {
            assertions.validTraitFor(image: element,
                                     file,
                                     line)
        }

        if tests.contains(.buttonTrait) {
            assertions.validTraitFor(button: element,
                                     file,
                                     line)
        }

        if tests.contains(.header) {
            assertions.hasHeader(element)
        }

        if tests.contains(.disabled) {
            assertions.disabled(element,
                                file,
                                line)
        }

        if tests.contains(.conflictingTraits) {
            assertions.conflictingTraits(element,
                                         file,
                                         line)
        }
        for element2 in elements {
            if tests.contains(.duplicated) {
                assertions.duplicatedLabels(element,
                                            element2)
            }

            if tests.contains(.controlSpacing) || tests.contains(.controlOverlap) {
                assertions.controlSpacing(element, element2, tests: tests)
            }
        }
    }
}
