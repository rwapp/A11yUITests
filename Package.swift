// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "A11yUITests",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "A11yUITests",
            targets: ["A11yUITests"]
        ),
    ],
    targets: [
        .target(
            name: "A11yUITests",
            dependencies: [],
            path: "Sources/A11yUITests"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
