// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "flutter_idv",
    platforms: [.iOS("14.0")],
    products: [.library(name: "flutter-idv", targets: ["flutter_idv"])],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(
            url: "https://github.com/regulaforensics/IDVSDK-Swift-Package",
            exact: "3.9.1987"
        ),
    ],
    targets: [
        .target(
            name: "flutter_idv",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "IDVSDK", package: "IDVSDK-Swift-Package"),
            ]
        ),
    ]
)
