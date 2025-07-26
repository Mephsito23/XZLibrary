// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XZUIKitUtils",
    platforms: [
        .iOS(.v15),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "XZUIKitUtils",
            targets: ["XZUIKitUtils"]
        )
    ],
    dependencies: [
        .package(path: "../XZCore"),
        .package(path: "../XZFoundationUtils")
    ],
    targets: [
        .target(
            name: "XZUIKitUtils",
            dependencies: ["XZCore", "XZFoundationUtils"]
        ),
        .testTarget(
            name: "XZUIKitUtilsTests",
            dependencies: ["XZUIKitUtils"]
        )
    ]
)