// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XZCore",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "XZCore",
            targets: ["XZCore"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "XZCore",
            dependencies: []
        ),
        .testTarget(
            name: "XZCoreTests",
            dependencies: ["XZCore"]
        )
    ]
)