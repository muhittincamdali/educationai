import Foundation

public struct ContentMetadata: Codable {
    public let tags: [String]
    public let language: String
    public let targetAge: ClosedRange<Int>
    public let estimatedDuration: TimeInterval
    public let prerequisites: [String]
    public let learningObjectives: [String]
    public let accessibilityFeatures: [AccessibilityFeature]
    
    public init(
        tags: [String] = [],
        language: String = "en",
        targetAge: ClosedRange<Int> = 5...18,
        estimatedDuration: TimeInterval = 0,
        prerequisites: [String] = [],
        learningObjectives: [String] = [],
        accessibilityFeatures: [AccessibilityFeature] = []
    ) {
        self.tags = tags
        self.language = language
        self.targetAge = targetAge
        self.estimatedDuration = estimatedDuration
        self.prerequisites = prerequisites
        self.learningObjectives = learningObjectives
        self.accessibilityFeatures = accessibilityFeatures
    }
}
