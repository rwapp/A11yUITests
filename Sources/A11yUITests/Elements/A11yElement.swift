//
//  A11yElement.swift
//  A11yUITests
//
//  Created by Rob Whitaker on 08/12/2019.
//

import XCTest

struct A11yElement {
    struct CodableElement: Codable {
        static let version = 1

        let label: String
        let frame: CGRect
        let type: String
        let traits: [String]
        let enabled: Bool
        let placeholder: String?
        let value: String?
    }

    typealias A11ySnapshot = XCUIElementSnapshot & NSObject

    let label: String
    let frame: CGRect
    let type: XCUIElement.ElementType
    let underlyingElement: XCUIElement
    let traits: UIAccessibilityTraits?
    let enabled: Bool
    let placeholder: String?
    let value: String?
    let id = UUID()
    let axIdentifier: String

    var shouldIgnore: Bool {
        return type == .window ||
            type == .scrollBar ||
            type == .other ||
            type == .navigationBar ||
            type == .table ||
            type == .scrollView ||
            type == .key ||
            type == .keyboard ||
            type == .tabBar
    }

    var isInteractive: Bool {
        // strictly switches, steppers, sliders, segmented controls, & text fields should be included
        // but standard iOS implementations aren't large enough.

        return self.type == .button ||
            self.type == .cell
    }

    var isControl: Bool {
        return type == .button ||
            type == .slider ||
            type == .stepper ||
            type == .segmentedControl ||
            type == .textField ||
            type == .switch ||
            type == .pageIndicator ||
            type == .link ||
            type == .searchField ||
            type == .secureTextField ||
            type == .datePicker ||
            type == .picker ||
            type == .pickerWheel ||
            type == .cell
    }

    var description: String {
        "\(itemLabel) \(self.type.name())"
    }

    var itemLabel: String {
        let noIdentifier = "[No identifier]"
        var itemLabel: String

        let label = self.label.count > 0 ? "Label: \"\(self.label)\"" : nil
        let identifier = self.axIdentifier.count > 0 ? "Identifier: \"\(axIdentifier)\"" : nil

        switch A11yTestValues.preferredItemLabel {
        case .label:
            itemLabel = label ?? identifier ?? noIdentifier
        case .identifier:
            itemLabel = identifier ?? label ?? noIdentifier
        case .both:
            itemLabel = [label, identifier].compactMap { $0 }
                .joined(separator: ", ")

            if itemLabel.count < 1 {
                itemLabel = noIdentifier
            }
        }

        return itemLabel
    }

    var codable: CodableElement? {
        guard !shouldIgnore else { return nil }

        return CodableElement(label: label,
                              frame: frame,
                              type: type.name(),
                              traits: traits?.names() ?? UIAccessibilityTraits.none.names(),
                              enabled: enabled,
                              placeholder: placeholder,
                              value: value)
    }

    init(_ element: XCUIElement) {
        label = element.label
        frame = element.frame
        type = element.elementType
        underlyingElement = element
        enabled = element.isEnabled
        placeholder = element.placeholderValue
        value = element.value as? String
        axIdentifier = element.identifier


        guard let snapshot = try? element.snapshot() as? A11ySnapshot else {
            traits = nil
            return
        }

        traits = snapshot.getTraits()
    }
}
