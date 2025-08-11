import Foundation

public struct PersonalizedContent: Codable, Identifiable {
    public let id: UUID
    public let originalContent: EducationalContent
    public let adaptedContent: EducationalContent
    public let personalizationFactors: PersonalizationFactors
    public let metadata: PersonalizedMetadata
    public let createdAt: Date
    
    public init(
        id: UUID = UUID(),
        originalContent: EducationalContent,
        adaptedContent: EducationalContent,
        personalizationFactors: PersonalizationFactors,
        metadata: PersonalizedMetadata,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.originalContent = originalContent
        self.adaptedContent = adaptedContent
        self.personalizationFactors = personalizationFactors
        self.metadata = metadata
        self.createdAt = createdAt
    }
}
