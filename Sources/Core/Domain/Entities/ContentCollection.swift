import Foundation

public struct ContentCollection: Codable, Identifiable {
    public let id: UUID
    public let title: String
    public let description: String
    public let subject: Subject
    public let targetAudience: TargetAudience
    public let content: [EducationalContent]
    public let curationCriteria: CurationCriteria
    public let createdAt: Date
    public let curator: String
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        subject: Subject,
        targetAudience: TargetAudience,
        content: [EducationalContent],
        curationCriteria: CurationCriteria,
        createdAt: Date = Date(),
        curator: String
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.subject = subject
        self.targetAudience = targetAudience
        self.content = content
        self.curationCriteria = curationCriteria
        self.createdAt = createdAt
        self.curator = curator
    }
}
