import Foundation

/// LearningUseCase - Core business logic for learning operations
/// Handles learning session management, progress tracking, and adaptive learning
@available(iOS 15.0, *)
public final class LearningUseCase {
    
    // MARK: - Dependencies
    private let learningEngine: LearningEngine
    private let progressTracker: ProgressTracker
    private let analyticsEngine: AnalyticsEngine
    
    // MARK: - Initialization
    public init(
        learningEngine: LearningEngine,
        progressTracker: ProgressTracker,
        analyticsEngine: AnalyticsEngine
    ) {
        self.learningEngine = learningEngine
        self.progressTracker = progressTracker
        self.analyticsEngine = analyticsEngine
    }
    
    // MARK: - Learning Session Management
    
    /// Start a new learning session
    /// - Parameters:
    ///   - subject: The subject to learn
    ///   - userProfile: User's profile and preferences
    ///   - learningPath: Optional predefined learning path
    /// - Returns: Configured learning session
    public func startLearningSession(
        for subject: Subject,
        userProfile: UserProfile,
        learningPath: LearningPath? = nil
    ) async throws -> LearningSession {
        
        // Validate prerequisites
        try validatePrerequisites(for: subject, userProfile: userProfile)
        
        // Create or retrieve learning path
        let path: LearningPath
        if let existingPath = learningPath {
            path = existingPath
        } else {
            path = try await generateLearningPath(for: subject, userProfile: userProfile)
        }
        
        // Initialize session
        let session = LearningSession(
            userId: userProfile.id,
            subjectId: subject.id,
            learningPath: path
        )
        
        // Configure adaptive learning
        try await configureAdaptiveLearning(for: session, userProfile: userProfile)
        
        // Track session start
        try await progressTracker.recordProgress(LearningProgress(
            userId: userProfile.id,
            subjectId: subject.id,
            type: .sessionStarted,
            value: 1.0,
            unit: .count,
            description: "Started learning session for \(subject.name)",
            metadata: ProgressMetadata(
                context: "Session started",
                difficulty: nil,
                effort: nil,
                mood: nil,
                environment: nil,
                trend: nil,
                notes: "Started learning session for \(subject.name)",
                customData: ["sessionId": session.id.uuidString, "subjectId": subject.id.uuidString]
            )
        ))
        
        return session
    }
    
    /// Pause current learning session
    /// - Parameter session: Active learning session
    public func pauseLearningSession(_ session: inout LearningSession) async throws {
        guard session.status == .active else {
            throw LearningError.invalidSessionState
        }
        
        session.pause()
        
        // Save progress
        try await saveSessionProgress(session)
        
        // Track pause
        try await progressTracker.recordProgress(LearningProgress(
            userId: session.userId,
            subjectId: session.subjectId,
            type: .sessionPaused,
            value: session.progress,
            unit: .percentage,
            description: "Paused learning session",
            metadata: ProgressMetadata(
                context: "Session paused",
                difficulty: nil,
                effort: nil,
                mood: nil,
                environment: nil,
                trend: nil,
                notes: "Paused learning session",
                customData: ["sessionId": session.id.uuidString, "subjectId": session.subjectId.uuidString]
            )
        ))
    }
    
    /// Resume paused learning session
    /// - Parameter session: Paused learning session
    public func resumeLearningSession(_ session: inout LearningSession) async throws {
        guard session.status == .paused else {
            throw LearningError.invalidSessionState
        }
        
        session.resume()
        
        // Update adaptive learning based on pause duration
        try await updateAdaptiveLearning(for: session)
        
        // Track resume
        try await progressTracker.recordProgress(LearningProgress(
            userId: session.userId,
            subjectId: session.subjectId,
            type: .sessionResumed,
            value: session.progress,
            unit: .percentage,
            description: "Resumed learning session",
            metadata: ProgressMetadata(
                context: "Session resumed",
                difficulty: nil,
                effort: nil,
                mood: nil,
                environment: nil,
                trend: nil,
                notes: "Resumed learning session",
                customData: ["sessionId": session.id.uuidString, "subjectId": session.subjectId.uuidString]
            )
        ))
    }
    
    /// Complete learning session
    /// - Parameter session: Active learning session
    public func completeLearningSession(_ session: inout LearningSession) async throws {
        guard session.status == .active || session.status == .paused else {
            throw LearningError.invalidSessionState
        }
        
        session.complete()
        
        // Calculate final metrics
        let finalMetrics = try await calculateSessionMetrics(session)
        
        // Update user progress
        try await updateUserProgress(session: session, metrics: finalMetrics)
        
        // Generate recommendations
        let recommendations = try await generatePostSessionRecommendations(session: session)
        
        // Track completion
        try await progressTracker.recordProgress(LearningProgress(
            userId: session.userId,
            subjectId: session.subjectId,
            type: .sessionCompleted,
            value: 100.0,
            unit: .percentage,
            description: "Completed learning session",
            metadata: ProgressMetadata(
                context: "Session completed",
                difficulty: nil,
                effort: nil,
                mood: nil,
                environment: nil,
                trend: nil,
                notes: "Completed learning session",
                customData: ["sessionId": session.id.uuidString, "subjectId": session.subjectId.uuidString, "finalScore": String(finalMetrics.averageScore)]
            )
        ))
        
        // Analytics
        analyticsEngine.trackSessionCompletion(session, metrics: finalMetrics)
    }
    
    // MARK: - Progress Tracking
    
    /// Record lesson completion
    /// - Parameters:
    ///   - lesson: Completed lesson
    ///   - session: Current learning session
    public func recordLessonCompletion(
        _ lesson: Lesson,
        in session: inout LearningSession
    ) async throws {
        
        session.addLessonCompletion(lesson)
        
        // Update progress
        let progress = LearningProgress(
            userId: session.userId,
            subjectId: session.subjectId,
            type: .lessonCompleted,
            value: session.progress,
            unit: .percentage,
            description: "Completed lesson: \(lesson.title)",
            metadata: ProgressMetadata(
                context: "Lesson completed",
                difficulty: nil,
                effort: nil,
                mood: nil,
                environment: nil,
                trend: nil,
                notes: "Completed lesson: \(lesson.title)",
                customData: ["sessionId": session.id.uuidString, "subjectId": session.subjectId.uuidString, "lessonId": lesson.id.uuidString]
            )
        )
        
        progressTracker.recordProgress(progress)
        
        // Adaptive learning update
        try await updateLearningPath(for: session, afterLesson: lesson)
    }
    
    /// Record quiz result
    /// - Parameters:
    ///   - result: Quiz result
    ///   - session: Current learning session
    public func recordQuizResult(
        _ result: QuizResult,
        in session: inout LearningSession
    ) async throws {
        
        session.addQuizResult(result)
        
        // Analyze performance
        let performance = analyzeQuizPerformance(result)
        
        // Update difficulty if needed
        if performance.requiresDifficultyAdjustment {
            try await adjustDifficulty(for: session, basedOn: performance)
        }
        
        // Track progress
        let progress = LearningProgress(
            userId: session.userId,
            subjectId: session.subjectId,
            type: .quizCompleted,
            value: result.score,
            unit: .percentage,
            description: "Quiz completed with \(result.score)% score",
            metadata: ProgressMetadata(
                context: "Quiz completed",
                difficulty: nil,
                effort: nil,
                mood: nil,
                effort: nil,
                mood: nil,
                environment: nil,
                trend: nil,
                notes: "Quiz completed with \(result.score)% score",
                customData: ["sessionId": session.id.uuidString, "subjectId": session.subjectId.uuidString, "quizId": result.quizId.uuidString, "performance": String(performance.performanceScore)]
            )
        )
        
        progressTracker.recordProgress(progress)
    }
    
    // MARK: - Adaptive Learning
    
    /// Update learning path based on performance
    /// - Parameters:
    ///   - session: Current learning session
    ///   - lesson: Recently completed lesson
    private func updateLearningPath(
        for session: LearningSession,
        afterLesson lesson: Lesson
    ) async throws {
        
        let performance = lesson.performance
        let userProfile = session.userProfile
        
        // Analyze learning patterns
        let patterns = try await analyzeLearningPatterns(for: userProfile, in: session.subject)
        
        // Generate adaptive recommendations
        let recommendations = try await generateAdaptiveRecommendations(
            for: session,
            basedOn: performance,
            patterns: patterns
        )
        
        // Update learning path
        session.updateLearningPath(with: recommendations)
        
        // Track adaptation
        progressTracker.recordProgress(LearningProgress(
            type: .pathAdapted,
            value: 1.0,
            unit: .count,
            description: "Learning path adapted based on performance",
            metadata: ProgressMetadata(
                context: "Path adapted",
                difficulty: nil,
                effort: nil,
                mood: nil,
                environment: nil,
                trend: nil,
                notes: "Learning path adapted based on performance",
                customData: ["sessionId": session.id.uuidString, "subjectId": session.subjectId.uuidString]
            )
        ))
    }
    
    /// Adjust difficulty based on performance
    /// - Parameters:
    ///   - session: Current learning session
    ///   - performance: Performance analysis
    private func adjustDifficulty(
        for session: LearningSession,
        basedOn performance: QuizPerformance
    ) async throws {
        
        let currentDifficulty = session.learningPath.difficultyLevel
        let newDifficulty = calculateOptimalDifficulty(
            current: currentDifficulty,
            performance: performance
        )
        
        if newDifficulty != currentDifficulty {
            try await updateSessionDifficulty(session, to: newDifficulty)
        }
    }
    
    // MARK: - Analytics and Insights
    
    /// Get learning insights for user
    /// - Parameter userProfile: User's profile
    /// - Returns: Comprehensive learning insights
    public func getLearningInsights(for userProfile: UserProfile) async throws -> LearningInsights {
        
        let progress = try await progressTracker.getProgress(for: userProfile)
        let analytics = try await analyticsEngine.getAnalytics(for: userProfile)
        
        return LearningInsights(
            userProfile: userProfile,
            progress: progress,
            analytics: analytics,
            recommendations: try await generateInsightBasedRecommendations(
                progress: progress,
                analytics: analytics
            )
        )
    }
    
    // MARK: - Private Helper Methods
    
    private func validatePrerequisites(for subject: Subject, userProfile: UserProfile) throws {
        let userSkills = userProfile.skillLevel
        let requiredSkills = subject.prerequisites
        
        for prerequisite in requiredSkills {
            if !userSkills.contains(where: { $0.name == prerequisite.name && $0.level.rawValue >= prerequisite.level.rawValue }) {
                throw LearningError.prerequisitesNotMet(prerequisite.name)
            }
        }
    }
    
    private func generateLearningPath(for subject: Subject, userProfile: UserProfile) async throws -> LearningPath {
        // Implementation would integrate with AIEngine
        return LearningPath(
            subject: subject,
            difficultyLevel: userProfile.skillLevel.first?.level ?? .beginner,
            estimatedDuration: subject.estimatedDuration,
            lessons: []
        )
    }
    
    private func configureAdaptiveLearning(for session: LearningSession, userProfile: UserProfile) async throws {
        // Implementation would integrate with AIEngine
    }
    
    private func saveSessionProgress(_ session: LearningSession) async throws {
        // Implementation would integrate with persistence layer
    }
    
    private func updateAdaptiveLearning(for session: LearningSession) async throws {
        // Implementation would integrate with AIEngine
    }
    
    private func calculateSessionMetrics(_ session: LearningSession) async throws -> SessionMetrics {
        // Implementation would calculate comprehensive session metrics
        return SessionMetrics(
            duration: session.duration,
            lessonsCompleted: session.completedLessons.count,
            quizzesTaken: session.quizResults.count,
            averageScore: session.progress,
            engagementScore: 0.8,
            difficultyLevel: .beginner
        )
    }
    
    private func updateUserProgress(session: LearningSession, metrics: SessionMetrics) async throws {
        // Implementation would update user's overall progress
    }
    
    private func generatePostSessionRecommendations(session: LearningSession) async throws -> [ContentRecommendation] {
        // Implementation would generate next steps and recommendations
        return []
    }
    
    private func analyzeQuizPerformance(_ result: QuizResult) -> QuizPerformance {
        // Implementation would analyze quiz performance
        return .excellent
    }
    
    private func analyzeLearningPatterns(for userProfile: UserProfile, in subject: Subject) async throws -> [LearningPattern] {
        // Implementation would analyze user's learning patterns
        return []
    }
    
    private func generateAdaptiveRecommendations(
        for session: LearningSession,
        basedOn performance: LessonPerformance,
        patterns: [LearningPattern]
    ) async throws -> [AdaptiveRecommendation] {
        // Implementation would generate adaptive recommendations
        return []
    }
    
    private func calculateOptimalDifficulty(
        current: DifficultyLevel,
        performance: QuizPerformance
    ) -> DifficultyLevel {
        // Implementation would calculate optimal difficulty
        return current
    }
    
    private func updateSessionDifficulty(_ session: LearningSession, to difficulty: DifficultyLevel) async throws {
        // Implementation would update session difficulty
    }
    
    private func generateInsightBasedRecommendations(
        progress: [LearningProgress],
        analytics: LearningAnalytics
    ) async throws -> [ContentRecommendation] {
        // Implementation would generate recommendations based on insights
        return []
    }
}

// MARK: - Supporting Types

public struct LearningInsights {
    public let userProfile: UserProfile
    public let progress: [LearningProgress]
    public let analytics: LearningAnalytics
    public let recommendations: [ContentRecommendation]
}

// SessionMetrics struct is defined in Sources/Core/Domain/Entities/SessionMetrics.swift

// These enums are already defined in LearningSession.swift

public struct LearningPattern {
    public let type: PatternType
    public let strength: Double
    public let confidence: Double
    
    public enum PatternType: String, CaseIterable {
        case visualLearner, auditoryLearner, kinestheticLearner
        case morningLearner, eveningLearner, consistentLearner
        case quickLearner, thoroughLearner, reviewFocused
    }
}

public enum LearningError: Error, LocalizedError {
    case invalidSessionState
    case prerequisitesNotMet(String)
    case sessionNotFound
    case invalidProgressData
    
    public var errorDescription: String? {
        switch self {
        case .invalidSessionState:
            return "Learning session is in an invalid state for this operation"
        case .prerequisitesNotMet(let subject):
            return "Prerequisites not met for subject: \(subject)"
        case .sessionNotFound:
            return "Learning session not found"
        case .invalidProgressData:
            return "Invalid progress data provided"
        }
    }
}
