//
//  XCUIElement.ElementType+Name.swift
//  A11yUITests
//
//  Created by Rob Whitaker on 26/03/2021.
//

import XCTest

internal extension XCUIElement.ElementType {
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
