//
//  NSObject+Extensions.swift
//  A11yUITests
//
//  Created by Rob Whitaker on 28/03/2021.
//

import Foundation

extension NSObject {

    // This code kindly provided by [Chris Kolbu](https://github.com/nesevis)

    func optionalValue<T>(for key: String) -> T? {
        guard self.responds(to: Selector(key)),
              let value = self.value(forKey: key) else {
            print("Unable to get property \"\(type(of: self)).\(key)\". This is likely due to a change in Apple's private API. Please raise an issue https://github.com/rwapp/A11yUITests/issues")
            return nil
        }

        guard let castValue = value as? T else {
            print("Unable to cast property \"\(type(of: self)).\(key)\" from `\(type(of: value))` to `\(T.self)`. This is likely due to a change in Apple's private API. Please raise an issue https://github.com/rwapp/A11yUITests/issues")
            return nil
        }
        
        return castValue
    }
}
