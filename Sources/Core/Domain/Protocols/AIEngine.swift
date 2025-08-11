import Foundation

public protocol AIEngine {
    func predictLearningOutcomes(for userProfile: UserProfile, subject: Subject, timeframe: TimeInterval) async throws -> [LearningPrediction]
    func predictPerformanceTrends(for userProfile: UserProfile, metric: String, timeRange: TimeRange) async throws -> [PerformancePrediction]
    func processNaturalLanguageQuery(_ query: String, context: LearningContext) async throws -> QueryResponse
    func rankContentRecommendations(_ candidates: [EducationalContent], for userProfile: UserProfile, context: LearningContext?) async throws -> [EducationalContent]
    func enhanceContent(_ content: EducationalContent) async throws -> EducationalContent
}
