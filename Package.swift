// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "EducationAI",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "EducationAI", targets: ["EducationAI"])
    ],
    targets: [
        .target(name: "EducationAI"),
        .testTarget(
            name: "EducationAITests",
            dependencies: ["EducationAI"],
            resources: [.copy("Fixtures")]
        )
    ]
)
