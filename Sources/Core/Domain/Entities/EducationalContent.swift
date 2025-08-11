import Foundation

public struct EducationalContent: Codable, Identifiable {
    public let id: UUID
    public let title: String
    public let description: String
    public let content: String
    public let subject: Subject
    public let difficultyLevel: DifficultyLevel
    public let format: ContentFormat
    public let metadata: ContentMetadata
    public let status: ContentStatus
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        content: String,
        subject: Subject,
        difficultyLevel: DifficultyLevel,
        format: ContentFormat,
        metadata: ContentMetadata,
        status: ContentStatus,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.content = content
        self.subject = subject
        self.difficultyLevel = difficultyLevel
        self.format = format
        self.metadata = metadata
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
