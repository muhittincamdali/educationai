// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "EducationAI",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "EducationAI",
            targets: ["EducationAI"]
        ),
    ],
    dependencies: [
        .package(path: "../SwiftAI")
    ],
    targets: [
        .target(
            name: "EducationAI",
            dependencies: ["SwiftAI"],
            path: "Sources/EducationAI"
        ),
        .testTarget(
            name: "EducationAITests",
            dependencies: ["EducationAI"],
            path: "Tests/EducationAITests"
        ),
    ]
)
