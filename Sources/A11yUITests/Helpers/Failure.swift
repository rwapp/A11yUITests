//
//  Failure.swift
//  A11yUITests
//
//  Created by Rob Whitaker on 12/07/2022.
//

import Foundation

enum Failure: String {
    case failure, warning

    var message: String {
        let prefix = self == .warning ? "⚠️" : "❌"
        return "\(prefix) Accessibility \(self.rawValue.capitalized)"
    }
}
