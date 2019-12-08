//
//  A11yElement.swift
//  A11yUITests
//
//  Created by Rob Whitaker on 08/12/2019.
//

import XCTest

struct A11yElement {
    let label: String
    let frame: CGRect
    let type: XCUIElement.ElementType
    let underlyingElement: XCUIElement

    var isWindow: Bool {
        return self.type == .window
    }

    var isInteractive: Bool {
        // strictly switches, steppers, sliders, segmented controls, & text fields should be included
        // but standard iOS implimentations aren't large enough.

        return self.type == .button ||
            self.type == .cell
    }

    var description: String {
        return "\"\(self.label)\" \(self.type)"
    }
}
