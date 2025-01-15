// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.iOS(.v18)],
    products: [
        .library(name: "Core", targets: ["Core"])
    ],
    dependencies: [
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", from: "4.2.2")
    ],
    targets: [
        .plugin(
            name: "RunMockolo",
            capability: .buildTool(),
            dependencies: [.target(name: "mockolo")]
        ),
        .binaryTarget(
            name: "mockolo",
            url: "https://github.com/uber/mockolo/releases/download/2.2.0/mockolo-macos.artifactbundle.zip",
            checksum: "26aa998f46cc6e814accf6014571116368fd7f772ce060de63ac8b36069d33fe"
        ),
        .target(
            name: "Core",
            dependencies: [.product(name: "KeychainAccess", package: "KeychainAccess"),],
            plugins: [.plugin(name: "RunMockolo")]
        ),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core"]
        ),
    ]
)
