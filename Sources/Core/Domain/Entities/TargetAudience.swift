import Foundation

public struct TargetAudience: Codable {
    public let ageRange: ClosedRange<Int>
    public let skillLevel: SkillLevel
    public let learningStyle: LearningStyle
    public let interests: [String]
    
    public init(
        ageRange: ClosedRange<Int> = 5...18,
        skillLevel: SkillLevel = .beginner,
        learningStyle: LearningStyle = .visual,
        interests: [String] = []
    ) {
        self.ageRange = ageRange
        self.skillLevel = skillLevel
        self.learningStyle = learningStyle
        self.interests = interests
    }
}
