import Foundation

public struct PersonalizationFactors: Codable {
    public let learningStyle: LearningStyle
    public let difficultyAdjustment: DifficultyAdjustment
    public let contentPreferences: UserContentPreferences
    public let accessibilityNeeds: [AccessibilityFeature]
    
    public init(
        learningStyle: LearningStyle,
        difficultyAdjustment: DifficultyAdjustment,
        contentPreferences: UserContentPreferences,
        accessibilityNeeds: [AccessibilityFeature] = []
    ) {
        self.learningStyle = learningStyle
        self.difficultyAdjustment = difficultyAdjustment
        self.contentPreferences = contentPreferences
        self.accessibilityNeeds = accessibilityNeeds
    }
}
