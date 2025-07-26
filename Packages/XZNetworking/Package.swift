// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XZNetworking",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "XZNetworking",
            targets: ["XZNetworking"]
        )
    ],
    dependencies: [
        .package(path: "../XZCore")
    ],
    targets: [
        .target(
            name: "XZNetworking",
            dependencies: ["XZCore"]
        ),
        .testTarget(
            name: "XZNetworkingTests",
            dependencies: ["XZNetworking"]
        )
    ]
)