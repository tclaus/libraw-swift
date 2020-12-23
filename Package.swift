// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftLibRaw",
    products: [
        .library(
            name: "SwiftLibRaw",
            targets: ["SwiftLibRaw"]),
    ],
    dependencies: [],
    targets: [
        .systemLibrary(name: "libraw", pkgConfig: "libraw", providers: [.brew(["libraw"])]),
        .target(
            name: "SwiftLibRaw",
            dependencies: ["libraw"]),
        .testTarget(
            name: "SwiftLibRawTests",
            dependencies: ["SwiftLibRaw"]),
    ]
)
