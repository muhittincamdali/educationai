import Foundation

public struct PersonalizedMetadata: Codable {
    public let userSpecificTags: [String]
    public let difficultyRating: Double
    public let estimatedCompletionTime: TimeInterval
    public let prerequisites: [String]
    
    public init(
        userSpecificTags: [String] = [],
        difficultyRating: Double = 0.0,
        estimatedCompletionTime: TimeInterval = 0,
        prerequisites: [String] = []
    ) {
        self.userSpecificTags = userSpecificTags
        self.difficultyRating = difficultyRating
        self.estimatedCompletionTime = estimatedCompletionTime
        self.prerequisites = prerequisites
    }
}
