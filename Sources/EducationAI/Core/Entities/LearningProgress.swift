import Foundation

/// Snapshot of a learner's progress across subjects.
public struct LearningProgress: Codable, Sendable {

    /// Per-subject progress data keyed by subject ID.
    public var subjects: [UUID: SubjectProgress]

    /// Cumulative study events (most recent first).
    public var recentEvents: [StudyEvent]

    /// Total study time in seconds.
    public var totalStudyTime: TimeInterval

    /// Total number of cards reviewed.
    public var totalReviews: Int

    /// Overall accuracy across all subjects (0-1).
    public var overallAccuracy: Double {
        guard totalReviews > 0 else { return 0 }
        let correct = recentEvents.filter { $0.rating.isCorrect }.count
        return Double(correct) / Double(totalReviews)
    }

    /// Global mastery score (0-1) averaged across subjects.
    public var globalMastery: Double {
        let values = subjects.values.map(\.masteryScore)
        guard !values.isEmpty else { return 0 }
        return values.reduce(0, +) / Double(values.count)
    }

    public init(
        subjects: [UUID: SubjectProgress] = [:],
        recentEvents: [StudyEvent] = [],
        totalStudyTime: TimeInterval = 0,
        totalReviews: Int = 0
    ) {
        self.subjects = subjects
        self.recentEvents = recentEvents
        self.totalStudyTime = totalStudyTime
        self.totalReviews = totalReviews
    }
}

// MARK: - Subject Progress

/// Progress within a single subject.
public struct SubjectProgress: Codable, Sendable {

    public let subjectID: UUID

    /// Total cards in this subject.
    public var totalCards: Int

    /// Cards that have been reviewed at least once.
    public var reviewedCards: Int

    /// Cards considered "mastered" (interval ≥ 21 days).
    public var masteredCards: Int

    /// Average accuracy for this subject (0-1).
    public var accuracy: Double

    /// Mastery score (0-1).
    public var masteryScore: Double {
        guard totalCards > 0 else { return 0 }
        return Double(masteredCards) / Double(totalCards)
    }

    /// Study time in seconds for this subject.
    public var studyTime: TimeInterval

    /// When this subject was last studied.
    public var lastStudied: Date?

    /// Current difficulty level recommended for this subject.
    public var recommendedDifficulty: DifficultyLevel

    public init(
        subjectID: UUID,
        totalCards: Int = 0,
        reviewedCards: Int = 0,
        masteredCards: Int = 0,
        accuracy: Double = 0,
        studyTime: TimeInterval = 0,
        lastStudied: Date? = nil,
        recommendedDifficulty: DifficultyLevel = .medium
    ) {
        self.subjectID = subjectID
        self.totalCards = totalCards
        self.reviewedCards = reviewedCards
        self.masteredCards = masteredCards
        self.accuracy = accuracy
        self.studyTime = studyTime
        self.lastStudied = lastStudied
        self.recommendedDifficulty = recommendedDifficulty
    }
}

// MARK: - Study Event

/// A single study interaction recorded over time.
public struct StudyEvent: Codable, Sendable, Identifiable {

    public var id: UUID { UUID(uuidString: "\(cardID)-\(timestamp.timeIntervalSince1970)") ?? UUID() }

    /// Card that was studied.
    public let cardID: UUID

    /// Subject the card belongs to.
    public let subjectID: UUID

    /// Self-reported recall quality.
    public let rating: RecallRating

    /// Time in seconds to answer.
    public let responseTime: TimeInterval

    /// When the study event occurred.
    public let timestamp: Date

    public init(
        cardID: UUID,
        subjectID: UUID,
        rating: RecallRating,
        responseTime: TimeInterval,
        timestamp: Date = Date()
    ) {
        self.cardID = cardID
        self.subjectID = subjectID
        self.rating = rating
        self.responseTime = responseTime
        self.timestamp = timestamp
    }
}
