// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UDFCrashlyticsLogger",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "UDFCrashlyticsLogger",
            targets: ["UDFCrashlyticsLogger"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Maks-Jago/SwiftUI-UDF", from: "1.4.1-alpha.6"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.0.0")
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
