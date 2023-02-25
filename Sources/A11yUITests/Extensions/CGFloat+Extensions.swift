//
//  CGFloat+Extensions.swift
//  A11yUITests
//
//  Created by Rob Whitaker on 25/02/2023.
//

import Foundation

extension CGFloat {
    var printable: String {
        String(format: "%.2f", self)
    }
}
