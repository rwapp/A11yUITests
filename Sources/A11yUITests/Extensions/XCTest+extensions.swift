//
//  XCTest+extensions.swift
//  A11yUITests
//
//  Created by Rob Whitaker on 25/02/2023.
//

import XCTest

func A11yAssertGreaterThanOrEqual<T>(_ expression1: @autoclosure () -> T,
                                     _ expression2: @autoclosure () -> T,
                                     message: String,
                                     elements: [A11yElement]? = nil,
                                     reason: String? = nil,
                                     severity: Failure,
                                     file: StaticString,
                                     line: UInt)  where T : Comparable {
    guard !(expression1() >= expression2()) else { return }

    fail(severity.message, report(message, elements, reason), file, line)
}

func A11yAssertGreaterThan<T>(_ expression1: @autoclosure () -> T,
                              _ expression2: @autoclosure () -> T,
                              message: String,
                              elements: [A11yElement]? = nil,
                              reason: String? = nil,
                              severity: Failure,
                              file: StaticString,
                              line: UInt)  where T : Comparable {
    guard expression2() >= expression1() else { return }

    fail(severity.message, report(message, elements, reason), file, line)
}

func A11yAssertFalse(_ expression: @autoclosure () -> Bool,
                     message: String,
                     elements: [A11yElement]? = nil,
                     reason: String? = nil,
                     severity: Failure,
                     file: StaticString,
                     line: UInt) {
    guard expression() else { return }

    fail(severity.message, report(message, elements, reason), file, line)
}

func A11yAssert(_ expression: @autoclosure () -> Bool,
                message: String,
                elements: [A11yElement]? = nil,
                reason: String? = nil,
                severity: Failure,
                file: StaticString,
                line: UInt) {
    guard !expression() else { return }

    fail(severity.message, report(message, elements, reason), file, line)
}

func A11yAssertNil(_ expression: @autoclosure () -> Any?,
                   message: String,
                   elements: [A11yElement]? = nil,
                   reason: String? = nil,
                   severity: Failure,
                   file: StaticString,
                   line: UInt) {
    guard expression() != nil else { return }

    fail(severity.message, report(message, elements, reason), file, line)
}

func A11yAssertEqual<T>(_ expression1: @autoclosure () -> T,
                        _ expression2: @autoclosure () -> T,
                        message: String,
                        elements: [A11yElement]? = nil,
                        reason: String? = nil,
                        severity: Failure,
                        file: StaticString,
                        line: UInt) where T : Equatable {
    guard expression1() != expression2() else { return }

    fail(severity.message, report(message, elements, reason), file, line)
}

func A11yAssertEqual<T>(_ expression1: @autoclosure () -> T,
                        _ expression2: @autoclosure () -> T,
                        accuracy: T,
                        message: String,
                        elements: [A11yElement]? = nil,
                        reason: String? = nil,
                        severity: Failure,
                        file: StaticString,
                        line: UInt) where T : FloatingPoint {
    guard ((expression1() - expression2()) - accuracy) > 0 else { return }

    fail(severity.message, report(message, elements, reason), file, line)
}

func A11yAssertLessThanOrEqual<T>(_ expression1: @autoclosure () -> T,
                                  _ expression2: @autoclosure () -> T,
                                  message: String,
                                  elements: [A11yElement]? = nil,
                                  reason: String? = nil,
                                  severity: Failure,
                                  file: StaticString,
                                  line: UInt) where T : Comparable {
    guard expression1() > expression2() else { return }

    fail(severity.message, report(message, elements, reason), file, line)
}

func A11yAssertNotEqual<T>(_ expression1: @autoclosure () -> T,
                           _ expression2: @autoclosure () -> T,
                           message: String,
                           elements: [A11yElement]? = nil,
                           reason: String? = nil,
                           severity: Failure,
                           file: StaticString,
                           line: UInt) where T : Equatable {
    guard expression1() == expression2() else { return }

    fail(severity.message, report(message, elements, reason), file, line)
}

func A11yFail(message: String,
              elements: [A11yElement]? = nil,
              reason: String? = nil,
              severity: Failure,
              file: StaticString,
              line: UInt) {
    fail(severity.message, report(message, elements, reason), file, line)
}

private func fail(_ failure: String,
                  _ message: String,
                  _ file: StaticString,
                  _ line: UInt) {
    _XCTPreformattedFailureHandler(nil, false, String(file), Int(line), failure, message)
}

private func report(_ message: String,
                    _ elements: [A11yElement]?,
                    _ reason: String?
) -> String {

    var reasonMessage = ""
    if let reason = reason {
        reasonMessage = "\n\(reason)"
    }

    let elementMessage = elements?.compactMap { $0 }
        .map { "\($0.description)" }
        .joined(separator: ", ")
        .description
        .appending(".")
        .prepending("\n")
    ?? ""

    return "\(message)\(elementMessage)\(reasonMessage)"
}
