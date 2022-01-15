import Foundation

public struct SkillGap: Codable, Identifiable {
    public let id: UUID
    public let skillName: String
    public let currentLevel: SkillLevel
    public let requiredLevel: SkillLevel
    public let gapSize: Int
    public let priority: Priority
    
    public init(
        id: UUID = UUID(),
        skillName: String,
        currentLevel: SkillLevel,
        requiredLevel: SkillLevel,
        gapSize: Int,
        priority: Priority
    ) {
        self.id = id
        self.skillName = skillName
        self.currentLevel = currentLevel
        self.requiredLevel = requiredLevel
        self.gapSize = gapSize
        self.priority = priority
    }
}
