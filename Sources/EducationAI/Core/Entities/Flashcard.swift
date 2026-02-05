import Foundation

/// A single flashcard with front/back content and spaced-repetition metadata.
public struct Flashcard: Identifiable, Codable, Sendable, Hashable {

    // MARK: - Identity

    /// Unique identifier.
    public let id: UUID

    /// The subject this card belongs to.
    public let subjectID: UUID

    // MARK: - Content

    /// The question / prompt shown to the learner.
    public var front: String

    /// The correct answer or explanation.
    public var back: String

    /// Optional tags for categorization.
    public var tags: [String]

    /// Difficulty tier assigned by the content creator.
    public var difficulty: DifficultyLevel

    // MARK: - Spaced Repetition State (SM-2)

    /// Current easiness factor (≥ 1.3).
    public var easinessFactor: Double

    /// Number of consecutive correct recalls.
    public var repetitionCount: Int

    /// Current inter-repetition interval in days.
    public var intervalDays: Double

    /// When this card should next be reviewed.
    public var nextReviewDate: Date

    /// When this card was last reviewed.
    public var lastReviewDate: Date?

    // MARK: - Statistics

    /// Total times this card has been reviewed.
    public var totalReviews: Int

    /// Total times recalled correctly.
    public var correctCount: Int

    /// Creation timestamp.
    public let createdAt: Date

    // MARK: - Initialization

    public init(
        id: UUID = UUID(),
        subjectID: UUID,
        front: String,
        back: String,
        tags: [String] = [],
        difficulty: DifficultyLevel = .medium,
        easinessFactor: Double = 2.5,
        repetitionCount: Int = 0,
        intervalDays: Double = 0,
        nextReviewDate: Date = Date(),
        lastReviewDate: Date? = nil,
        totalReviews: Int = 0,
        correctCount: Int = 0,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.subjectID = subjectID
        self.front = front
        self.back = back
        self.tags = tags
        self.difficulty = difficulty
        self.easinessFactor = easinessFactor
        self.repetitionCount = repetitionCount
        self.intervalDays = intervalDays
        self.nextReviewDate = nextReviewDate
        self.lastReviewDate = lastReviewDate
        self.totalReviews = totalReviews
        self.correctCount = correctCount
        self.createdAt = createdAt
    }

    // MARK: - Computed

    /// Accuracy rate as a value between 0 and 1.
    public var accuracy: Double {
        guard totalReviews > 0 else { return 0 }
        return Double(correctCount) / Double(totalReviews)
    }

    /// Whether this card is due for review.
    public var isDue: Bool {
        nextReviewDate <= Date()
    }

    /// Whether this card has never been reviewed.
    public var isNew: Bool {
        totalReviews == 0
    }

    /// Returns a lapse (forgotten) status based on recent performance.
    public var isLapsed: Bool {
        repetitionCount == 0 && totalReviews > 0
    }
}
