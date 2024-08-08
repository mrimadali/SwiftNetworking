// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftNetworking",
    platforms: [
           .iOS(.v15),       // Minimum iOS 13.0
           .macOS(.v13),  // Minimum macOS 10.15
           .watchOS(.v6),    // Minimum watchOS 6.0
           .tvOS(.v13)       // Minimum tvOS 13.0
       ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftNetworking",
            targets: ["SwiftNetworking"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftNetworking",
            path: "Sources"),
        .testTarget(
            name: "SwiftNetworkingTests",
            dependencies: ["SwiftNetworking"]),
    ]
)
