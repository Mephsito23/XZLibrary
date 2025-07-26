// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XZAppKitUtils",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "XZAppKitUtils",
            targets: ["XZAppKitUtils"]
        )
    ],
    dependencies: [
        .package(path: "../XZCore"),
        .package(path: "../XZFoundationUtils")
    ],
    targets: [
        .target(
            name: "XZAppKitUtils",
            dependencies: ["XZCore", "XZFoundationUtils"]
        ),
        .testTarget(
            name: "XZAppKitUtilsTests",
            dependencies: ["XZAppKitUtils"]
        )
    ]
)