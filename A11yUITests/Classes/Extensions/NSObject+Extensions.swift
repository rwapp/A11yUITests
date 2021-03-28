//
//  NSObject+Extensions.swift
//  A11yUITests
//
//  Created by Rob Whitaker on 28/03/2021.
//

import Foundation

extension NSObject {
    @objc
    func nilValue(_ key: String) -> Any? {
        print("Unable to get property \"\(key)\". This is likely due to a change in Apple's private API. Please raise an issue https://github.com/rwapp/A11yUITests/issues")
        return nil
    }
}
