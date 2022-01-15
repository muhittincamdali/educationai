import Foundation

public struct SkillProgression: Codable, Identifiable {
    public let id: UUID
    public let skillName: String
    public let fromLevel: SkillLevel
    public let toLevel: SkillLevel
    public let progressDate: Date
    public let confidence: Double
    
    public init(
        id: UUID = UUID(),
        skillName: String,
        fromLevel: SkillLevel,
        toLevel: SkillLevel,
        progressDate: Date = Date(),
        confidence: Double
    ) {
        self.id = id
        self.skillName = skillName
        self.fromLevel = fromLevel
        self.toLevel = toLevel
        self.progressDate = progressDate
        self.confidence = confidence
    }
}
