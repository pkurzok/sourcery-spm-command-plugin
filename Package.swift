// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MockGenerator",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MockGenerator",
            targets: ["MockGenerator"]),
        .plugin(
            name: "MockGeneratorPlugin",
            targets: ["MockGeneratorPlugin"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/krzysztofzablocki/Sourcery", branch: "master")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MockGenerator",
            dependencies: []),

        .plugin(name: "MockGeneratorPlugin",
                capability: .command(
                    intent: .custom(verb: "generate-protocol-mock", description: "Some Description"),
                    permissions: [.writeToPackageDirectory(reason: "Needed to create your Mocks")]),
                dependencies: [
                    .product(name: "sourcery", package: "Sourcery")
                ])
    ])
