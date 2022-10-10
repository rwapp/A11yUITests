//
//  AssertGreaterThan.swift
//  A11yUITests
//
//  Created by Ryan Ferrell at SeedFi on 10/08/2022.
//

import XCTest
@testable import A11yUITests

final class AssertGreaterThanTests: XCTestCase {

  func testPassesExactValues() {
    let testCases = [CGFloat.zero, .init(A11yValues.minSize), 100.0]
    let tolerance = 0.0
    testCases.forEach { value in
      let result = value.isMoreThanOrEqual(to: value, tolerance: tolerance)
      XCTAssertTrue(result, "\(value)")
    }
  }

  func testFailsNonExactValues() {
    let testCases = [CGFloat.zero, .init(A11yValues.minSize), 100.0]
    let tolerance = 0.0
    let offset = 1.0

    testCases.forEach { value in
      let offsetValue = value + offset
      let result = value.isMoreThanOrEqual(to: offsetValue, tolerance: tolerance)
      XCTAssertFalse(result, "\(value)")
    }
  }

  func testPassesGreaterValues() {
    let testCases = [CGFloat.zero, .init(A11yValues.minSize), 100.0]
    let tolerance = A11yValues.floatComparisonTolerance

    testCases.forEach { value in
      let offsetValue = value + tolerance / 2
      let result = offsetValue.isMoreThanOrEqual(to: value, tolerance: tolerance)
      XCTAssertTrue(result, "Within tolerance: \(value)")
    }

    testCases.forEach { value in
      let offsetValue = value + tolerance * 2
      let result = offsetValue.isMoreThanOrEqual(to: value, tolerance: tolerance)
      XCTAssertTrue(result, "Beyond tolerance: \(value)")
    }
  }

  func testPassesLesserValues_WithinTolerance() {
    let testCases = [CGFloat.zero, .init(A11yValues.minSize), 100.0]
    let tolerance = A11yValues.floatComparisonTolerance
    let offset = A11yValues.floatComparisonTolerance / 2

    testCases.forEach { value in
      let offsetValue = value + offset
      let result = value.isMoreThanOrEqual(to: offsetValue, tolerance: tolerance)
      XCTAssertTrue(result, "\(value)")
    }
  }

  func testFailsLesserValues_OutsideTolerance() {
    let testCases = [CGFloat.zero, .init(A11yValues.minSize), 100.0]
    let tolerance = A11yValues.floatComparisonTolerance
    let offset = A11yValues.floatComparisonTolerance * 2

    testCases.forEach { value in
      let offsetValue = value + offset
      let result = value.isMoreThanOrEqual(to: offsetValue, tolerance: tolerance)
      XCTAssertFalse(result, "\(value)")
    }
  }
}
