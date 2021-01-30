// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "feather-promocode-module",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PromoCode",
            targets: ["PromoCode"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/FeatherCMS/feather-core", from: "1.0.0-beta"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "PromoCode",
            dependencies: [
                .product(name: "FeatherCore", package: "feather-core")],
            resources: [
                .copy("Bundle/")
            ]),
        .testTarget(
            name: "feather-promocode-moduleTests",
            dependencies: ["PromoCode"]),
    ]
)
