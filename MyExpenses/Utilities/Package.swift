// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Utilities",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "PieChart",     // <<< это имя ты используешь в проекте
            targets: ["PieChart"] // <<< имя таргета
        )
    ],
    targets: [
        .target(
            name: "PieChart",     // <<< имя таргета совпадает с продуктом
            path: "Sources/PieChart"
        )
    ]
)

