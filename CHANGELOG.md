# Changelog

## 1.0.1

- Adding XCUIElement.identifier to error message

## 1.0.0

- Addition of snapshot testing

## 0.6.1

- Change to floating point assertion accuracy

## 0.6.0

- Adds a test to flag conflicting accessibility traits
- Adds ❌ to failure messages and ⚠️ to warning messages for improved prominence

## 0.5.2

- Adds the ability to ignore elements when running `a11yCheckAllOnScreen()`

## 0.5.1

- Fixed a bug that was causing the library to fail to compile for some users

## 0.5.0

- Adds the ability to specify minimum size and maximum label length
- Reduces the default minimum size value to 14
- Improved failure messages - issues that are not strict failures but require investigation are now marked as 'Warning'
- Now defaults to checking all interactive elements for minimum size of 44px. Can be overridden by setting `allInteractiveElements` to false.

## 0.4.1

- Swift Package Manager support

## 0.4.0

- Added checks for traits
  - Buttons
  - Headers
  - Images
- Added a check for disabled interactive elements
- Removed references to individual tests from the docs as a soft deprecation

- Note: Checking for traits uses a private property on the iOS SDK. Be careful not to include this code in your shipped app as it may be rejected by Apple.

## 0.3.1

- Minor code quality improvements and clarification to the readme

## 0.3.0

- Improvements for label checks
  - Ability to specify minimum length
  - Reporting failure strings in failure reasons
  - Reporting minimum length in failure reasons
  - Minimum label length checks added to images and interactive elements
- Improved documentation

## 0.2.0

- Clarified function names - this is a breaking change from 0.1.0
- Added test for duplicated element labels
- Significant speed and reliability improvements
- Improved documentation

## 0.1.0

- Initial release
