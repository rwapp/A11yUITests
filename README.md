# A11yUITests

[![Version](https://img.shields.io/cocoapods/v/A11yUITests.svg?style=flat)](https://cocoapods.org/pods/A11yUITests)
[![License](https://img.shields.io/cocoapods/l/A11yUITests.svg?style=flat)](https://cocoapods.org/pods/A11yUITests)
[![Platform](https://img.shields.io/cocoapods/p/A11yUITests.svg?style=flat)](https://cocoapods.org/pods/A11yUITests)

A11yTests is an extension to `XCTestCase` that adds tests for common accessibility issues that can be run as part of an XCUI Test suite.

Tests can either be run separately or integrated into existing XCUI Tests.

## Running tests

Tests can be run individually or in suites.

### Running All Tests on All Eliments

```swift
func test_allTests() {
    XCUIApplication().launch()
    runAllA11yTestsOnScreen()
}
```

### Specifying Tests/Elements

To specify elements and tests use  `run(a11yTests: [A11yTests], on elements: [XCUIElement])` passing an array of tests to run and an array of eliments to run them on. To run all interactive element tests on all buttons:

```swift
func test_buttons() {
    let buttons = XCUIApplication().buttons.allElementsBoundByIndex
    run(a11yTests: interactiveA11yTestSuite, on: buttons)
}
```

To run a single test on a single eliment call that test directly. To check if a button has a valid accessibility label:

```swift
func test_individualTest_individualButton() {
    let button = XCUIApplication().buttons["My Button"]
    checkValidLabelFor(button: button)
}
```

## Test Suites

A11yUITests contains 4 pre-built test suites with tests suitible for different elements.

`allA11yTestSuite` Runs all tests.

`imageA11yTestSuite` Runs tests suitible for images.

`interactiveA11yTestSuite` runs tests suitible for interactive elements.

`labelA11yTestSuite` runs tests suitible for static text elements.


Alternatively you can create an array of `A11yTests` enum values for the tests you want to run.

## Tests

### Minimum Size

`minimumSize` or `checkValidSizeFor(element: XCUIElement)` checks an element is at least 18px x 18px.

Note: 18px is arbitrary.

### Minimum Interactive Size

`minimumInteractiveSize` or `checkValidSizeFor(interactiveElement: XCUIElement)` checks tappable elements are a minimum of 44px x 44px.
This satisfies [WCAG 2.1 Sucess Criteria 2.5.5 Target Size Level AAA](https://www.w3.org/TR/WCAG21/#target-size)

Note: Many of Apple's controls fail this requirement. For this reason, when running a suite of tests with `minimumInteractiveSize` only buttons and cells are checked. This may still result in some failures for `UITabBarButton`s for example.
For full compliance, you should run `checkValidSizeFor(interactiveElement: XCUIElement)` on any element that your user might interact with, eg. sliders, steppers, switches, segmented controls. But you will need to make your own subclass as Apple's are not strictly adherent to WCAG.

### Label Presence

`labelPresence` or `checkValidLabelFor(element: XCUIElement)` checks the element has an accessibility label that is a minimum of 2 characters long.
This counts towards [WCAG 2.1 Guideline 1.1 Text Alternatives](https://www.w3.org/TR/WCAG21/#text-alternatives) but does not guarantee compliance.

### Button Label

`buttonLabel` or `checkValidLabelFor(button: XCUIElement)` checks button labels begin with a capital letter and don't contain a full stop or the word button.
This follows [Apple's guidance for writing accessibility labels](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/iPhoneAccessibility/Making_Application_Accessible/Making_Application_Accessible.html#//apple_ref/doc/uid/TP40008785-CH102-SW6). Buttons should all have the button trait applied, but this is currently untestable.

Note: This test is not localised.

### Image Label

`imageLabel` or `checkValidLabelFor(image: XCUIElement)` checks accessible images don't contain the words image, picture, graphic, or icon, and checks that the label isn't reusing the image filename.
This follows [Apple's guidelines for writing accessibility labels](https://developer.apple.com/videos/play/wwdc2019/254/). Images should all have the image trait applied, but this is currently untestable. Care should be given when deciding whether to make images accessible to avoid creating unnecessary noise.

Note: This test is not localised.

### Label Length
`labelLength` or `checkLabelLength(element: XCUIElement)` checks accessibility labels are <= 40 characters.
This follows [Apple's guidelines for writing accessibility labels](https://developer.apple.com/videos/play/wwdc2019/254/).
Ideally, labels should be as short as possible while retaining meaning. If you feel your element needs more context consider adding an accessibility hint.


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

A11yUITests_ExampleUITests.swift contains example tests that show a fail for each test above.

## Requirements

iOS 11

Swift 5

## Installation

A11yUITests is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'A11yUITests'
```

## Author

Rob Whitaker, rw@rwapp.co.uk
https://mobilea11y.com

## License

A11yUITests is available under the MIT license. See the LICENSE file for more info.
