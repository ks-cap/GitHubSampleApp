// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let productionFeatures: [PackageDescription.Target.Dependency] = [
    "UsersFeature",
    "SettingsFeature"
]

let package = Package(
    name: "GitHubPackage",
    platforms: [.iOS(.v18)],
    products: [
        .library(name: "GitHubPackage", targets: ["ProductionApp"])
    ],
    dependencies: [
        // Libraries
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", from: "4.2.2")
    ],
    targets: [
        // App layer
        .target(
            name: "ProductionApp",
            dependencies: productionFeatures,
            path: "./Sources/App"
        ),
        // Feature layer
        .target(
            name: "UsersFeature",
            dependencies: [
                "Model",
                "UICore",
                "UseCase",
                "SettingsFeature"
            ],
            path: "./Sources/Features/Users"
        ),
        .target(
            name: "SettingsFeature",
            dependencies: [
                "Model",
                "UseCase"
            ],
            path: "./Sources/Features/Settings"
        ),
        // Data layer
        .target(
            name: "API",
            dependencies: [
                "Model",
                "LogCore",
                "KeychainAccessCore"
            ],
            path: "./Sources/Infra/API",
            plugins: [
                .plugin(name: "RunMockolo")
            ]
        ),
        .target(
            name: "UseCase",
            dependencies: [
                "API",
                "Model",
                "KeychainAccessCore"
            ],
            path: "./Sources/Domain/UseCase",
            plugins: [
                .plugin(name: "RunMockolo")
            ]
        ),
        .target(
            name: "Model",
            path: "./Sources/Domain/Model"
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
