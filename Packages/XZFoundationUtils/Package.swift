// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XZFoundationUtils",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "XZFoundationUtils",
            targets: ["XZFoundationUtils"]
        )
    ],
    dependencies: [
        .package(path: "../XZCore")
    ],
    targets: [
        .target(
            name: "XZFoundationUtils",
            dependencies: ["XZCore"]
        ),
        .testTarget(
            name: "XZFoundationUtilsTests",
            dependencies: ["XZFoundationUtils"]
        )
    ]
)