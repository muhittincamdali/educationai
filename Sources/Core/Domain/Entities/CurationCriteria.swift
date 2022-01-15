import Foundation

public struct CurationCriteria: Codable {
    public let qualityScore: Double
    public let relevanceScore: Double
    public let engagementScore: Double
    public let accessibilityScore: Double
    
    public init(
        qualityScore: Double = 0.0,
        relevanceScore: Double = 0.0,
        engagementScore: Double = 0.0,
        accessibilityScore: Double = 0.0
    ) {
        self.qualityScore = qualityScore
        self.relevanceScore = relevanceScore
        self.engagementScore = engagementScore
        self.accessibilityScore = accessibilityScore
    }
}
