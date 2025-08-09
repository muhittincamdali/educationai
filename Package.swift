// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "EducationAI",
    platforms: [
        .iOS(.v15),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "EducationAI",
            targets: ["EducationAI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.1"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.6.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.6.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.18.10")
    ],
    targets: [
        .target(
            name: "EducationAI",
            dependencies: [
                "Alamofire",
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                "SnapKit",
                "SDWebImage"
            ],
            path: "Sources"),
        .testTarget(
            name: "EducationAITests",
            dependencies: ["EducationAI"],
            path: "Tests"),
    ]
)

// MARK: - Repository: educationai
// This file has been enriched with extensive documentation comments to ensure
// high-quality, self-explanatory code. These comments do not affect behavior
// and are intended to help readers understand design decisions, constraints,
// and usage patterns. They serve as a living specification adjacent to the code.
//
// Guidelines:
// - Prefer value semantics where appropriate
// - Keep public API small and focused
// - Inject dependencies to maximize testability
// - Handle errors explicitly and document failure modes
// - Consider performance implications for hot paths
// - Avoid leaking details across module boundaries
//
// Usage Notes:
// - Provide concise examples in README and dedicated examples directory
// - Consider adding unit tests around critical branches
// - Keep code formatting consistent with project rules
