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
    let id = UUID()

    var shouldIgnore: Bool {
        return self.type == .window ||
            self.type == .scrollBar ||
            self.type == .other ||
            self.type == .navigationBar ||
            self.type == .table ||
            self.type == .scrollView ||
            self.type == .key ||
            self.type == .keyboard ||
            self.type == .tabBar
    }

    var isInteractive: Bool {
        // strictly switches, steppers, sliders, segmented controls, & text fields should be included
        // but standard iOS implementations aren't large enough.

        return self.type == .button ||
            self.type == .cell
    }

    var isControl: Bool {
        return self.type == .button ||
            self.type == .slider ||
            self.type == .stepper ||
            self.type == .segmentedControl ||
            self.type == .textField ||
            self.type == .switch ||
            self.type == .pageIndicator ||
            self.type == .link ||
            self.type == .searchField ||
            self.type == .secureTextField ||
            self.type == .datePicker ||
            self.type == .picker ||
            self.type == .pickerWheel
    }

    var description: String {
        return "\"\(self.label)\" \(self.type.name())"
    }

    init(_ element: XCUIElement) {
        label = element.label
        frame = element.frame
        type = element.elementType
        underlyingElement = element

        guard let snapshot = try? element.snapshot() as? A11ySnapshot else {
            traits = nil
            return
        }

        traits = snapshot.getTraits()
    }
}
