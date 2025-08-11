import Foundation

public protocol AnalyticsEngine {
    func generateLearningAnalytics(for userProfile: UserProfile, timeRange: TimeRange) async throws -> LearningAnalytics
    func trackProgress(_ progress: LearningProgress) async throws
    func trackAnalyticsGeneration(userProfile: UserProfile, timeRange: TimeRange, analyticsType: String) async throws
    func trackContentSearch(query: String, filters: ContentFilters, resultsCount: Int, userProfile: UserProfile) async throws
    func trackRecommendationGeneration(userProfile: UserProfile, recommendationsCount: Int, context: String?) async throws
    func trackContentCreation(content: EducationalContent, creator: ContentCreator) async throws
    func trackContentCuration(subject: Subject, targetAudience: TargetAudience, curatedCount: Int) async throws
    func getAnalytics(for userProfile: UserProfile) async throws -> LearningAnalytics
    func trackSessionCompletion(_ session: LearningSession, metrics: SessionMetrics) async throws
}
