//
//  A11yElement.swift
//  A11yUITests
//
//  Created by Rob Whitaker on 08/12/2019.
//

import XCTest

struct A11yElement {

    typealias A11ySnapshot = XCUIElementSnapshot & NSObject

    let label: String
    let frame: CGRect
    let type: XCUIElement.ElementType
    let underlyingElement: XCUIElement
    let traits: UIAccessibilityTraits?
    let enabled: Bool
    let id = UUID()

    var shouldIgnore: Bool {
        return type == .window ||
            type == .scrollBar ||
            type == .other ||
            type == .navigationBar ||
            type == .table ||
            type == .scrollView ||
            type == .key ||
            type == .keyboard ||
            type == .tabBar
    }

    var isInteractive: Bool {
        // strictly switches, steppers, sliders, segmented controls, & text fields should be included
        // but standard iOS implementations aren't large enough.

        return self.type == .button ||
            self.type == .cell
    }

    var isControl: Bool {
        return type == .button ||
            type == .slider ||
            type == .stepper ||
            type == .segmentedControl ||
            type == .textField ||
            type == .switch ||
            type == .pageIndicator ||
            type == .link ||
            type == .searchField ||
            type == .secureTextField ||
            type == .datePicker ||
            type == .picker ||
            type == .pickerWheel ||
            type == .cell
    }

    var description: String {
        return "\"\(self.label)\" \(self.type.name())"
    }

    init(_ element: XCUIElement) {
        label = element.label
        frame = element.frame
        type = element.elementType
        underlyingElement = element
        enabled = element.isEnabled

        guard let snapshot = try? element.snapshot() as? A11ySnapshot else {
            traits = nil
            return
        }

        traits = snapshot.getTraits()
    }
}
