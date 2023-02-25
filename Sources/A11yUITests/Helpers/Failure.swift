//
//  Failure.swift
//  A11yUITests
//
//  Created by Rob Whitaker on 12/07/2022.
//

import Foundation

enum Failure: String {
    case failure, warning

    func report(_ message: String,
                _ elements: [A11yElement]? = nil,
                reason: String? = nil
    ) -> String {

        var reasonMessage = ""
        if let reason = reason {
            reasonMessage = " \(reason)."
        }

        let elementMessage = elements?.compactMap { $0 }
            .map { "\($0.description)" }
            .joined(separator: ", ")
            .description
            .appending(".")
            .prepending(": ")
             ?? "."

        let prefix = self == .warning ? "⚠️" : "❌"

        return "\(prefix) Accessibility \(self.rawValue.capitalized): \(message)\(elementMessage)\(reasonMessage)"
    }
}
