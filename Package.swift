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
    targets: [
        .target(
            name: "EducationAI",
            path: "Sources/EducationAI"
        ),
        .testTarget(
            name: "EducationAITests",
            dependencies: ["EducationAI"],
            path: "Tests/EducationAITests"
        ),
    ]
)
