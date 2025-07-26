// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XZUIComponents",
    platforms: [
        .iOS(.v15),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "XZUIComponents",
            targets: ["XZUIComponents"]
        )
    ],
    dependencies: [
        .package(path: "../XZCore"),
        .package(path: "../XZUIKitUtils")
    ],
    targets: [
        .target(
            name: "XZUIComponents",
            dependencies: ["XZCore", "XZUIKitUtils"]
        ),
        .testTarget(
            name: "XZUIComponentsTests",
            dependencies: ["XZUIComponents"]
        )
    ]
)