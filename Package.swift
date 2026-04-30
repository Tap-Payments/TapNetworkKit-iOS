// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "TapNetworkKit_iOS",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "TapNetworkKit_iOS",
            targets: ["TapNetworkKit_iOS"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Tap-Payments/TapAdditionsKitV2.git", from: "0.0.18"),
        .package(url: "https://github.com/Tap-Payments/TapApplicationV2.git", from: "0.0.4"),
        .package(url: "https://github.com/Tap-Payments/CommonDataModelsKit-iOS.git", from: "1.0.149"),
        .package(url: "https://github.com/Tap-Payments/TapCardVlidatorKit-iOS.git", from: "1.0.24"),
        .package(url: "https://github.com/TakeScoop/SwiftyRSA.git", from: "1.7.0")
    ],
    targets: [
        .target(
            name: "TapNetworkKit_iOS",
            dependencies: [
                .product(name: "TapAdditionsKitV2", package: "TapAdditionsKitV2"),
                .product(name: "TapApplicationV2", package: "TapApplicationV2"),
                .product(name: "CommonDataModelsKit_iOS", package: "CommonDataModelsKit-iOS"),
                .product(name: "TapCardVlidatorKit-iOS", package: "TapCardVlidatorKit-iOS"),
                "SwiftyRSA"
            ],
            path: "TapNetworkKit-iOS/TapNetworkKit-iOS/Source/Core"
        )
    ],
    swiftLanguageVersions: [.v5]
)

