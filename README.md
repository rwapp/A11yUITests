# A11yUITests

[![Version](https://img.shields.io/cocoapods/v/A11yUITests.svg?style=flat)](https://cocoapods.org/pods/A11yUITests)
[![License](https://img.shields.io/cocoapods/l/A11yUITests.svg?style=flat)](https://cocoapods.org/pods/A11yUITests)
[![Platform](https://img.shields.io/cocoapods/p/A11yUITests.svg?style=flat)](https://cocoapods.org/pods/A11yUITests)
[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/M4M33JMAY)
[![Twitter](https://img.shields.io/twitter/follow/MobileA11y?style=flat)](https://twitter.com/mobilea11y)

A11yTests is an extension to `XCTestCase` that adds tests for common accessibility issues that can be run as part of an XCUI Test suite.

Tests can either be run separately or integrated into existing XCUI Tests.

## Using These Tests

Good accessibility is not about ticking boxes and conforming to regulations and guidelines, but about how your app is experienced. You will only ever know if your app is actually accessible by letting real people use it. Consider these tests as hints for where you might be able to do better, and use them to detect regressions.

Failures for these tests should be seen as warnings for further investigation, not strict failures. As such i'd recommend always having `continueAfterFailure = true` set.

Failures have two categories: Warning and Failure.
Failures are fails against WCAG or the HIG. Warnings may be acceptable, but require investigation.

add `import A11yUITests` to the top of your test file.


## Running Tests

Tests can be run individually or in suites.

### Running All Tests on All Elements

```swift
func test_allTests() {
    XCUIApplication().launch()
    a11yCheckAllOnScreen()
}
```

### Specifying Tests/Elements

To specify elements and tests use  `a11y(tests: [A11yTests], on elements: [XCUIElement])` passing an array of tests to run and an array of elements to run them on. To run all interactive element tests on all buttons:

```swift
func test_buttons() {
    let buttons = XCUIApplication().buttons.allElementsBoundByIndex
    a11y(tests: a11yTestSuiteInteractive, on: buttons)
}
```

To run a single test on a single element pass arrays with the test and element. To check if a button has a valid accessibility label:

```swift
func test_individualTest_individualButton() {
    let button = XCUIApplication().buttons["My Button"]
    a11y(tests: [.buttonLabel], on: [button])
}
```

### Ignoring Elements

When running `a11yCheckAllOnScreen()` it is possible to ignore elements using their accessibility idenfiers by passing any identifiers you wish to ignore with the `ignoringElementIdentifiers: [String]` argument.

## Test Suites

A11yUITests contains 4 pre-built test suites with tests suitable for different elements.

`a11yTestSuiteAll` Runs all tests.

`a11yTestSuiteImages` Runs tests suitable for images.

`a11yTestSuiteInteractive` runs tests suitable for interactive elements.

`a11yTestSuiteLabels` runs tests suitable for static text elements.


Alternatively you can create an array of `A11yTests` enum values for the tests you want to run.

## Tests

### Minimum Size

`minimumSize` or checks an element is at least 14px x 14px.
Severity: Warning

Note: 14px is arbitrary.

### Minimum Interactive Size

`minimumInteractiveSize` checks tappable elements are a minimum of 44px x 44px.
This satisfies [WCAG 2.1 Success Criteria 2.5.5 Target Size Level AAA](https://www.w3.org/TR/WCAG21/#target-size)
Severity: Error

Note: Many of Apple's controls fail this requirement. For this reason, when running a suite of tests with `minimumInteractiveSize` only buttons and cells are checked. This may still result in some failures for `UITabBarButton`s for example.
For full compliance, you should run `a11yCheckValidSizeFor(interactiveElement: XCUIElement)` on any element that your user might interact with, eg. sliders, steppers, switches, segmented controls. But you will need to make your own subclass as Apple's are not strictly adherent to WCAG.

### Label Presence

`labelPresence` checks the element has an accessibility label that is a minimum of 2 characters long. 
Pass a `minMeaningfulLength` argument to `a11yCheckValidLabelFor(element: XCUIElement, minMeaningfulLength: Int )` to change the minimum length.
This counts towards [WCAG 2.1 Guideline 1.1 Text Alternatives](https://www.w3.org/TR/WCAG21/#text-alternatives) but does not guarantee compliance.
Severity: Warning

### Button Label

`buttonLabel` checks labels for interactive elements begin with a capital letter and don't contain a period or the word button. Checks the label is a minimum of 2 characters long.
Pass a `minMeaningfulLength` argument to `a11yCheckValidLabelFor(interactiveElement: XCUIElement, minMeaningfulLength: Int )` to change the minimum length.
This follows [Apple's guidance for writing accessibility labels](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/iPhoneAccessibility/Making_Application_Accessible/Making_Application_Accessible.html).
Severity: Error

Note: This test is not localised.

### Image Label

`imageLabel` checks accessible images don't contain the words image, picture, graphic, or icon, and checks that the label isn't reusing the image filename. Checks the label is a minimum of 2 characters long.
Pass a `minMeaningfulLength` argument to `a11yCheckValidLabelFor(image: XCUIElement, minMeaningfulLength: Int )` to change the minimum length.
This follows [Apple's guidelines for writing accessibility labels](https://developer.apple.com/videos/play/wwdc2019/254/). Care should be given when deciding whether to make images accessible to avoid creating unnecessary noise.
Severity: Error


Note: This test is not localised.

### Label Length
`labelLength` checks accessibility labels are <= 40 characters.
This follows [Apple's guidelines for writing accessibility labels](https://developer.apple.com/videos/play/wwdc2019/254/).
Ideally, labels should be as short as possible while retaining meaning. If you feel your element needs more context consider adding an accessibility hint.
Severity: Warning

### Header
`header` checks the screen has at least one text element with a header trait.
Headers are used by VoiceOver users to orientate and quickly navigate content.
This follows [WCAG 2.1 Success Criterion 2.4.10](https://www.w3.org/WAI/WCAG21/Understanding/section-headings.html)
Severity: Error

### Button Trait
`buttonTrait` checks that a button element has the Button or Link trait applied.
This follows [Apple's guide for using traits](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/iPhoneAccessibility/Making_Application_Accessible/Making_Application_Accessible.html).
Severity: Error

### Image Trait
`imageTrait` checks that an image element has the Image trait applied.
This follows [Apple's guide for using traits](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/iPhoneAccessibility/Making_Application_Accessible/Making_Application_Accessible.html).
Severity: Error

### Conflicting Traits
`conflictingTraits` checks elements don't have conflicting traits.
Elements can't be both a button and a link, or static text and updates frequently

### Disabled Elements
`disabled` checks that elements aren't disabled.
Disabled elements can be confusing if it is not clear why the element is disabled. Ideally keep the element enabled and clearly message if your app is not ready to process the action.
Severity: Warning

### Duplicated Labels
`duplicated` checks all elements provided for duplication of accessibility labels.
Duplicated accessibility labels can make your screen confusing to navigate with VoiceOver, and make Voice Control fail. Ideally you should avoid duplication if possible.
Severity: Warning


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

A11yUITests_ExampleUITests.swift contains example tests that show a fail for each test above.

## Requirements

iOS 11

Swift 5

## Installation

### Swift Package Manager

This library support [Swift Package Manager](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app). Ensure the package is added as a dependancy to your UITests target, not your app's target.

### Cocoapods

A11yUITests is available through [CocoaPods](https://cocoapods.org). 
To install add the pod to your target's test target in your podfile. eg

```ruby
target 'My_Application' do
    target 'My_Application_UITests' do
    pod 'A11yUITests'
    end
end
```

## Note

* This library accesses a private property in the iOS SDK, so care should be taken when adding it to your project to ensure you are not shipping this code. If you submit this code to app review you will likely receive a rejection from Apple.
* This library uses method swizzling of the `value(forUndefinedKey:)` method on NSObject to guard against potential crashes if Apple changes their private API in future. Any calls to this function will return `nil` after running any tests. This affects your test suite only, not your app.

## Known Issues

If two elements of the same type have the same identifier (eg, two buttons both labeled 'Next') this will cause the tests to crash on some iOS versions. This was an issue on ios 13 and appears fixed as of iOS 15.

## Author

Rob Whitaker, rw@rwapp.co.uk\
https://mobilea11y.com

## License

A11yUITests is available under the MIT license. See the LICENSE file for more info.
