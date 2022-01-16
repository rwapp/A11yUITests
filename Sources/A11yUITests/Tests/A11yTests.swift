//
//  A11yTests.swift
//  A11yUITests
//
//  Created by Rob Whitaker on 26/03/2021.
//

public enum A11yTests: CaseIterable {
    case minimumSize,
         minimumInteractiveSize,
         labelPresence,
         buttonLabel,
         imageLabel,
         labelLength,
         duplicated,
         imageTrait,
         header,
         buttonTrait,
         conflictingTraits,
         disabled
}
