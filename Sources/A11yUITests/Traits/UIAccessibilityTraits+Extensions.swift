//
//  UIAccessibilityTraits+Extensions.swift
//  A11yUITests
//
//  Created by Rob Whitaker on 27/03/2021.
//

import UIKit

extension UIAccessibilityTraits {
    func name() -> String {

        if self == .none {
            return "None"
        }

        var traits = [String]()

        if self.contains(.button) {
            traits.append("Button")
        }
        if self.contains(.link) {
            traits.append("Link")
        }
        if self.contains(.header) {
            traits.append("Header")
        }
        if self.contains(.searchField) {
            traits.append("Search Field")
        }
        if self.contains(.image) {
            traits.append("Image")
        }
        if self.contains(.selected) {
            traits.append("Selected")
        }
        if self.contains(.playsSound) {
            traits.append("Plays Sound")
        }
        if self.contains(.keyboardKey) {
            traits.append("Keyboard Key")
        }
        if self.contains(.staticText) {
            traits.append("Static Text")
        }
        if self.contains(.summaryElement) {
            traits.append("Summary Element")
        }
        if self.contains(.notEnabled) {
            traits.append("Not Enabled")
        }
        if self.contains(.updatesFrequently) {
            traits.append("Updates Frequently")
        }
        if self.contains(.startsMediaSession) {
            traits.append("Starts Media Session")
        }
        if self.contains(.adjustable) {
            traits.append("Adjustable")
        }
        if self.contains(.allowsDirectInteraction) {
            traits.append("Allows Direct Interaction")
        }
        if self.contains(.causesPageTurn) {
            traits.append("Causes Page Turn")
        }
        if self.contains(.tabBar) {
            traits.append("Tab Bar")
        }

        return traits.joined(separator: ", ")
    }
}
