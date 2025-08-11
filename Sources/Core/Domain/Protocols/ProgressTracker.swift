import Foundation

public protocol ProgressTracker {
    func getProgress(for userProfile: UserProfile) async throws -> LearningProgress
    func updateProgress(_ progress: LearningProgress) async throws
    func trackSession(_ session: LearningSession) async throws
    func getSessionHistory(for userProfile: UserProfile) async throws -> [LearningSession]
    func recordProgress(_ progress: LearningProgress) async throws
}
