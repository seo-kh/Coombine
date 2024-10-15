// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Coombine",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Coombine",
            targets: ["Coombine"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Coombine"),
        .testTarget(
            name: "CoombineTests",
            dependencies: ["Coombine"]
        ),
    ]
)
