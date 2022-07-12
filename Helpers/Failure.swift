//
//  ErrorReporting.swift
//  A11yUITests
//
//  Created by Rob Whitaker on 12/07/2022.
//

import Foundation

enum Failure: String {
    case failure, warning

    func report(_ message: String,
                _ element1: A11yElement? = nil,
                _ element2: A11yElement? = nil,
                reason: String? = nil
    ) -> String {

        var reasonMessage = ""
        if let reason = reason {
            reasonMessage = " \(reason)."
        }

        var elementMessage = "."
        if let element1 = element1 {
            if let element2 = element2 {
                elementMessage = ": \(element1.description), \(element2.description)."
            } else {
                elementMessage = ": \(element1.description)."
            }
        }

        let prefix = self == .warning ? "⚠️" : "❌"

        return "\(prefix) Accessibility \(self.rawValue.capitalized): \(message)\(elementMessage)\(reasonMessage)"
    }
}
