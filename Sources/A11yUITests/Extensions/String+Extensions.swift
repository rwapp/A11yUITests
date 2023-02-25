//
//  String+Extensions.swift
//  A11yUITests
//
//  Created by Rob Whitaker on 28/03/2021.
//

import XCTest

internal extension String {

    init(_ staticString: StaticString) {
        self = staticString.withUTF8Buffer {
            String(decoding: $0, as: UTF8.self)
        }
    }

    func containsCaseInsensitive(_ substring: String) -> Bool {
        return self.lowercased().contains(substring.lowercased())
    }

    func containsWords(_ words : [String]) -> [String] {
        var contained = [String]()

        for word in words {
            if self.containsCaseInsensitive(word) {
                contained.append(word)
            }
        }

        return contained
    }
}

extension StringProtocol {
    func prepending<T>(_ aString: T) -> String where T : StringProtocol {
        "\(aString)\(self)"
    }
}
