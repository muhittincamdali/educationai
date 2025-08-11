import Foundation

public struct CrossSubjectSkill: Codable, Identifiable {
    public let id: UUID
    public let skillName: String
    public let subjects: [Subject]
    public let applications: [String]
    public let transferability: Double
    
    public init(
        id: UUID = UUID(),
        skillName: String,
        subjects: [Subject],
        applications: [String],
        transferability: Double
    ) {
        self.id = id
        self.skillName = skillName
        self.subjects = subjects
        self.applications = applications
        self.transferability = transferability
    }
}
