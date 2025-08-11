import Foundation

public struct Skill: Codable, Identifiable {
    public let id: UUID
    public let name: String
    public let description: String
    public let category: String
    public let currentLevel: SkillLevel
    public let targetLevel: SkillLevel
    public let prerequisites: [String]
    
    public init(
        id: UUID = UUID(),
        name: String,
        description: String,
        category: String,
        currentLevel: SkillLevel,
        targetLevel: SkillLevel,
        prerequisites: [String] = []
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.currentLevel = currentLevel
        self.targetLevel = targetLevel
        self.prerequisites = prerequisites
    }
}
