// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XZFileUtils",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "XZFileUtils",
            targets: ["XZFileUtils"]
        )
    ],
    dependencies: [
        .package(path: "../XZCore")
    ],
    targets: [
        .target(
            name: "XZFileUtils",
            dependencies: ["XZCore"]
        ),
        .testTarget(
            name: "XZFileUtilsTests",
            dependencies: ["XZFileUtils"]
        )
    ]
)