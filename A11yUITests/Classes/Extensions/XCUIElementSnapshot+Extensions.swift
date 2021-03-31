//
//  XCUIElementSnapshot+Extensions.swift
//  A11yUITests
//
//  Created by Rob Whitaker on 28/03/2021.
//

import XCTest

extension XCUIElementSnapshot where Self: NSObject {
    private func swizzle() {
        guard let undefinedKey = class_getInstanceMethod(NSObject.self,
                                                         #selector(NSObject.value(forUndefinedKey:))),
              let undefinedKeyNil = class_getInstanceMethod(NSObject.self,
                                                            #selector(NSObject.nilValue(_:))) else {
            print("Unable to swizzle \"value(forUndefinedKey:)\". Please raise an issue https://github.com/rwapp/A11yUITests/issues")
            return
        }

        method_exchangeImplementations(undefinedKey, undefinedKeyNil)
    }

    func getTraits() -> UIAccessibilityTraits? {
        swizzle()

        return value(forKey: "_traits") as? UIAccessibilityTraits
    }
}
