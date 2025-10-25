// swift-tools-version:6.2

import PackageDescription

let package = Package(
    name: "UIKitToolbox",
    platforms: [
        // Relevant platforms.
        .iOS(.v16), .macOS(.v13), .tvOS(.v16), .visionOS(.v1)
    ],
    products: [
        .library(name: "UIKitToolbox", targets: ["UIKitToolbox"])
    ],
    dependencies: [
        // It's a good thing to keep things relatively
        // independent, but add any dependencies here.
    ],
    targets: [
        .target(
            name: "UIKitToolbox",
            dependencies: [],
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug)),
                .define("RELEASE", .when(configuration: .release)),
                .define("SWIFT_PACKAGE")
            ]),
        .testTarget(name: "UIKitToolboxTests", dependencies: ["UIKitToolbox"]),
    ]
)
