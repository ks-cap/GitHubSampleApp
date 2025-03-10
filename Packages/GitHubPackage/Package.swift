// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GitHubPackage",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "GitHubPackage",
            targets: [
                "DevelopApp",
                "ProductionApp"
            ]
        )
    ],
    dependencies: [
        // Libraries
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", from: "4.2.2"),
        .package(url: "https://github.com/kean/Pulse", from: "5.1.2")
    ],
    targets: [
        // App layer
        .target(
            name: "DevelopApp",
            dependencies: [
                "DebugFeature",
                "SettingsFeature",
                "UsersFeature",
                .product(name: "Pulse", package: "Pulse"),
                .product(name: "PulseProxy", package: "Pulse")
            ],
            path: "./Sources/App/Develop"
        ),
        .target(
            name: "ProductionApp",
            dependencies: [
                "SettingsFeature",
                "UsersFeature"
            ],
            path: "./Sources/App/Production"
        ),
        // Build layer
        .target(
            name: "Build",
            path: "./Sources/Build"
        ),
        // Feature layer
        .target(
            name: "DebugFeature",
            dependencies: [
                .product(name: "PulseUI", package: "Pulse")
            ],
            path: "./Sources/Features/Debug"
        ),
        .target(
            name: "UsersFeature",
            dependencies: [
                "Data",
                "Domain",
                "Entity",
                "UICore",
                "SettingsFeature"
            ],
            path: "./Sources/Features/Users"
        ),
        .target(
            name: "SettingsFeature",
            dependencies: [
                "Data",
                "Domain",
                "Entity"
            ],
            path: "./Sources/Features/Settings"
        ),
        // Domain layer
        .target(
            name: "Domain",
            dependencies: [
                "Build",
                "Entity"
            ],
            path: "./Sources/Domain",
            plugins: [
                .plugin(name: "RunMockolo")
            ]
        ),
        // Data layer
        .target(
            name: "Data",
            dependencies: [
                "Build",
                "Domain",
                "Entity",
                "KeychainAccessCore",
                "LogCore"
            ],
            path: "./Sources/Data",
            plugins: [
                .plugin(name: "RunMockolo")
            ]
        ),
        // Entity layer
        .target(
            name: "Entity",
            path: "./Sources/Entity"
        ),
        // Core layer
        .target(
            name: "LogCore",
            path: "./Sources/Core/Log"
        ),
        .target(
            name: "UICore",
            path: "./Sources/Core/UI"
        ),
        .target(
            name: "KeychainAccessCore",
            dependencies: [
                .product(name: "KeychainAccess", package: "KeychainAccess")
            ],
            path: "./Sources/Core/KeychainAccess"
        ),
        .testTarget(
            name: "GitHubPackageTests",
            dependencies: [
                "KeychainAccessCore"
            ]
        ),
        // Build Tool Plugin
        .plugin(
            name: "RunMockolo",
            capability: .buildTool(),
            dependencies: [
                .target(name: "mockolo")
            ]
        ),
        .binaryTarget(
            name: "mockolo",
            url: "https://github.com/uber/mockolo/releases/download/2.2.0/mockolo-macos.artifactbundle.zip",
            checksum: "26aa998f46cc6e814accf6014571116368fd7f772ce060de63ac8b36069d33fe"
        )
    ]
)
