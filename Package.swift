// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XZLibrary",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    dependencies: [
        .package(path: "Packages/XZCore"),
        .package(path: "Packages/XZNetworking"),
        .package(path: "Packages/XZUIKitUtils"),
        .package(path: "Packages/XZUIComponents")
    ],
    targets: [
        .target(
            name: "XZLibrary",
            dependencies: ["XZCore", "XZNetworking", "XZUIKitUtils", "XZUIComponents"]
        ),
        .testTarget(
            name: "XZLibraryTests",
            dependencies: ["XZLibrary"]
        ),
    ]
)
