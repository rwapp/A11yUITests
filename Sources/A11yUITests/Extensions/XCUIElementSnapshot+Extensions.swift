//
//  XCUIElementSnapshot+Extensions.swift
//  A11yUITests
//
//  Created by Rob Whitaker on 28/03/2021.
//

import XCTest

internal extension XCUIElementSnapshot where Self: NSObject {
    var traits: UIAccessibilityTraits? {
        optionalValue(for: "traits")
    }
}
