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
}

private extension XCUIElement.ElementType {
    func name() -> String {
        switch self {
        case .staticText:
            return "Label"
        case .button:
            return "Button"
        case .textField:
            return "Text Field"
        case .cell:
            return "Cell"
        case .switch:
            return "Switch"
        case .alert:
            return "Alert"
        case .pageIndicator:
            return "Page Indicator"
        case .activityIndicator:
            return "Activity Indicator"
        case .link:
            return "Link"
        case .searchField:
            return "Search Field"
        case .slider:
            return "Slider"
        case .textView:
            return "Text View"
        case .secureTextField:
            return "Secure Text Field"
        case .datePicker:
            return "Date Picker"
        case .stepper:
            return "Stepper"
        case .dialog:
            return "Dialog"
        case .progressIndicator:
            return "Progress Indicator"
        case .segmentedControl:
            return "Segmented Control"
        case .picker:
            return "Picker"
        case .pickerWheel:
            return "Picker Wheel"
        case .image:
            return "Image"

        default:
            return "Other"
        }
    }
}
