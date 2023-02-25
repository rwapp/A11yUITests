//
//  Values.swift
//  A11yUITests
//
//  Created by Rob Whitaker on 19/04/2021.
//

import CoreGraphics

public enum A11yTestValues {
    public enum ReportValue {
        case label, identifier, both
    }

    public static let minSize = 14
    public static let minInteractiveSize: CGFloat = 44.0
    public static let minMeaningfulLength = 2
    public static let maxMeaningfulLength = 40
    public static let allInteractiveElements = true
    public static let floatComparisonTolerance: CGFloat = 0.1
    public static let preferredItemLabel: ReportValue = .label
}
