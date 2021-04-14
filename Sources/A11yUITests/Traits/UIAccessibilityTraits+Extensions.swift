//
//  UIAccessibilityTraits+Extensions.swift
//  A11yUITests
//
//  Created by Rob Whitaker on 27/03/2021.
//

import UIKit

extension UIAccessibilityTraits {
    func name() -> String {
        switch self {
        case .none:
            return "none"
        case .button:
            return "Button"
        case .link:
            return "Link"
        case .searchField:
            return "Search Field"
        case .image:
            return "Image"
        case .selected:
            return "Selected"
        case .playsSound:
            return "Plays Sound"
        case .keyboardKey:
            return "Keyboard Key"
        case .staticText:
            return "Static Text"
        case .summaryElement:
            return "Summary Element"
        case .notEnabled:
            return "Not enabled"
        case .updatesFrequently:
            return "Updates Frequently"
        case .startsMediaSession:
            return "Starts Media Session"
        case .adjustable:
            return "Adjustable"
        case .allowsDirectInteraction:
            return "Allows Direct Interaction"
        case .causesPageTurn:
            return "Causes Page Turn"
        case .header:
            return "Header"
        default:
            return "Unknown"
        }
    }
}
