import Foundation

public protocol LearningEngine {
    func startLearningSession(for userProfile: UserProfile, subject: Subject, learningPath: LearningPath?) async throws -> LearningSession
    func pauseSession(_ session: LearningSession) async throws
    func resumeSession(_ session: LearningSession) async throws
    func completeSession(_ session: LearningSession) async throws
    func addLessonCompletion(_ lesson: Lesson, to session: LearningSession) async throws
    func addQuizResult(_ result: QuizResult, to session: LearningSession) async throws
    func generateLearningPath(for subject: Subject, userProfile: UserProfile) async throws -> LearningPath
    func validatePrerequisites(for subject: Subject, userProfile: UserProfile) async throws -> Bool
}
