// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PluginArchitecture",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "PluginArchitecture",
            targets: ["PluginArchitecture"]),
        .executable(
            name: "PluginDemo",
            targets: ["PluginDemo"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "PluginArchitecture",
            dependencies: []),
        .executableTarget(
            name: "PluginDemo",
            dependencies: ["PluginArchitecture"]),
        .testTarget(
            name: "PluginArchitectureTests",
            dependencies: ["PluginArchitecture"]),
    ]
)
