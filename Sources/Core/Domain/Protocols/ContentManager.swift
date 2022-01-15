import Foundation

public protocol ContentManager {
    func searchContent(query: String, filters: ContentFilters) async throws -> [EducationalContent]
    func getRecommendations(for userProfile: UserProfile, context: LearningContext?) async throws -> [EducationalContent]
    func createContent(_ content: EducationalContent, creator: ContentCreator, validationRules: ContentValidationRules) async throws -> EducationalContent
    func updateContent(_ content: EducationalContent) async throws
    func deleteContent(_ content: EducationalContent) async throws
    func getContentAnalytics(_ content: EducationalContent, timeRange: TimeRange) async throws -> ContentAnalytics
}
