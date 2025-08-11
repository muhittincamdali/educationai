import Foundation

public struct ContentAnalytics: Codable, Identifiable {
    public let id: UUID
    public let content: EducationalContent
    public let engagement: EngagementMetrics
    public let outcomes: LearningOutcomes
    public let feedback: [UserFeedback]
    public let effectivenessScore: Double
    public let timeRange: TimeRange
    public let generatedAt: Date
    
    public init(
        id: UUID = UUID(),
        content: EducationalContent,
        engagement: EngagementMetrics,
        outcomes: LearningOutcomes,
        feedback: [UserFeedback],
        effectivenessScore: Double,
        timeRange: TimeRange,
        generatedAt: Date = Date()
    ) {
        self.id = id
        self.content = content
        self.engagement = engagement
        self.outcomes = outcomes
        self.feedback = feedback
        self.effectivenessScore = effectivenessScore
        self.timeRange = timeRange
        self.generatedAt = generatedAt
    }
}
