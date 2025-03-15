// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "SetgreetSDK",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SetgreetSDK",
            targets: ["SetgreetSDK"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "SetgreetSDK",
            path: "./SetgreetSDK.xcframework"
        )
    ]
)
