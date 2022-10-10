//
//  AssertGreaterThan.swift
//  A11yUITests
//
//  Created by Ryan Ferrell at SeedFi on 10/08/2022.
//

import Foundation

extension CGFloat {

  func isMoreThanOrEqual(
    to targetValue: CGFloat,
    tolerance: CGFloat = 0
  ) -> Bool {
    self >= (targetValue - abs(tolerance))
  }
}
