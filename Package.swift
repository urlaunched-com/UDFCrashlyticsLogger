// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UDFCrashlyticsLogger",
    platforms: [
        .iOS(.v16),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "UDFCrashlyticsLogger",
            targets: ["UDFCrashlyticsLogger"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Maks-Jago/SwiftUI-UDF", from: "1.4.4-rc.1"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.20.0")
    ],
    targets: [
        .target(
            name: "UDFCrashlyticsLogger",
            dependencies: [
                .product(name: "UDF", package: "SwiftUI-UDF"),
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk")
            ]
        )
    ]
)
