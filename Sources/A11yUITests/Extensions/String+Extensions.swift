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

    func doesNotContain(_ words : [String],
                        _ error: String,
                        _ file: StaticString,
                        _ line: UInt) {

        for word in words {
            XCTAssertFalse(self.containsCaseInsensitive(word),
                           "\(error) Offending word: \(word).",
                           file: file,
                           line: line)
        }
    }
}
