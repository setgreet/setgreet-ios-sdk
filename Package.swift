// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "SetgreetSDK",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Core SDK — no third-party dependencies, no Lottie symbols.
        .library(
            name: "SetgreetSDK",
            targets: ["SetgreetSDK"]
        ),
        // Optional Lottie animation support. Add this product ONLY if your flows
        // use Lottie components, and ALSO add the Lottie package to your app
        // target (SPM binaryTargets cannot declare their own dependencies):
        //
        //   .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.6.0")
        //   .product(name: "Lottie", package: "lottie-spm")
        //
        // Then call `SetgreetLottie.register()` once at app startup.
        .library(
            name: "SetgreetSDKLottie",
            targets: ["SetgreetSDKLottie"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "SetgreetSDK",
            path: "./SetgreetSDK.xcframework"
        ),
        .binaryTarget(
            name: "SetgreetSDKLottie",
            path: "./SetgreetSDKLottie.xcframework"
        )
    ]
)
