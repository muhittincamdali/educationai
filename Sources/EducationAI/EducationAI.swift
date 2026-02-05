import Foundation

/// EducationAI — Privacy-first adaptive learning framework for Apple platforms.
///
/// Provides quiz generation, spaced repetition, adaptive difficulty,
/// progress tracking, content recommendation and gamification — all on-device.
///
/// ```swift
/// let engine = EducationAI()
///
/// // Generate a quiz
/// let quiz = engine.quizEngine.generate(
///     from: flashcards,
///     count: 10,
///     difficulty: .adaptive
/// )
///
/// // Schedule review with spaced repetition
/// let schedule = engine.spacedRepetition.nextReview(for: card, rating: .good)
/// ```
public final class EducationAI: @unchecked Sendable {

    // MARK: - Engines

    /// Quiz generation engine.
    public let quizEngine: QuizEngine

    /// SM-2 based spaced repetition scheduler.
    public let spacedRepetition: SpacedRepetitionScheduler

    /// Adaptive difficulty engine.
    public let adaptiveEngine: AdaptiveDifficultyEngine

    /// Learning progress tracker.
    public let progressTracker: ProgressTracker

    /// Content recommendation engine.
    public let recommendationEngine: RecommendationEngine

    /// Gamification system (XP, badges, streaks).
    public let gamification: GamificationEngine

    /// On-device persistent storage.
    public let storage: LocalStorage

    // MARK: - Configuration

    /// Current framework configuration.
    public let configuration: EducationAIConfiguration

    // MARK: - Initialization

    /// Create an EducationAI instance with custom configuration.
    /// - Parameter configuration: Framework configuration. Defaults to `.default`.
    public init(configuration: EducationAIConfiguration = .default) {
        self.configuration = configuration
        self.storage = LocalStorage(suiteName: configuration.storageSuite)
        self.spacedRepetition = SpacedRepetitionScheduler(parameters: configuration.sm2Parameters)
        self.quizEngine = QuizEngine()
        self.adaptiveEngine = AdaptiveDifficultyEngine(
            sensitivity: configuration.adaptiveSensitivity
        )
        self.progressTracker = ProgressTracker(storage: storage)
        self.recommendationEngine = RecommendationEngine()
        self.gamification = GamificationEngine(storage: storage)
    }

    // MARK: - Convenience

    /// Record a study event and update all subsystems at once.
    ///
    /// This is the easiest way to keep progress, gamification,
    /// and spaced repetition in sync.
    ///
    /// - Parameters:
    ///   - card: The flashcard that was studied.
    ///   - rating: Self-reported recall quality.
    ///   - responseTime: How long the user took to answer (seconds).
    /// - Returns: A ``StudyResult`` containing the updated card, XP earned, and next review date.
    @discardableResult
    public func recordStudy(
        card: Flashcard,
        rating: RecallRating,
        responseTime: TimeInterval
    ) -> StudyResult {
        // 1. Spaced repetition
        let updatedCard = spacedRepetition.review(card: card, rating: rating)

        // 2. Progress tracking
        let event = StudyEvent(
            cardID: card.id,
            subjectID: card.subjectID,
            rating: rating,
            responseTime: responseTime,
            timestamp: Date()
        )
        progressTracker.record(event: event)

        // 3. Adaptive difficulty
        adaptiveEngine.ingest(event: event)

        // 4. Gamification
        let xpEarned = gamification.awardXP(for: event)
        let newBadges = gamification.checkBadges(for: progressTracker)

        return StudyResult(
            updatedCard: updatedCard,
            xpEarned: xpEarned,
            newBadges: newBadges,
            nextReviewDate: updatedCard.nextReviewDate,
            currentStreak: gamification.currentStreak
        )
    }

    /// Framework version string.
    public static let version = "1.0.0"
}

// MARK: - Configuration

/// Configuration options for the EducationAI framework.
public struct EducationAIConfiguration: Sendable {

    /// UserDefaults suite name for persistent storage.
    public var storageSuite: String

    /// SM-2 algorithm parameters.
    public var sm2Parameters: SM2Parameters

    /// Adaptive difficulty sensitivity (0.0 = sluggish, 1.0 = aggressive).
    public var adaptiveSensitivity: Double

    /// Maximum number of new cards per day (spaced repetition).
    public var maxNewCardsPerDay: Int

    /// Maximum number of review cards per day.
    public var maxReviewsPerDay: Int

    public init(
        storageSuite: String = "com.educationai.storage",
        sm2Parameters: SM2Parameters = .default,
        adaptiveSensitivity: Double = 0.5,
        maxNewCardsPerDay: Int = 20,
        maxReviewsPerDay: Int = 100
    ) {
        self.storageSuite = storageSuite
        self.sm2Parameters = sm2Parameters
        self.adaptiveSensitivity = adaptiveSensitivity
        self.maxNewCardsPerDay = maxNewCardsPerDay
        self.maxReviewsPerDay = maxReviewsPerDay
    }

    /// Sensible defaults for most use cases.
    public static let `default` = EducationAIConfiguration()
}

// MARK: - Study Result

/// Aggregated result of a single study interaction.
public struct StudyResult: Sendable {
    /// The flashcard with updated repetition metadata.
    public let updatedCard: Flashcard
    /// XP earned from this interaction.
    public let xpEarned: Int
    /// Any newly unlocked badges.
    public let newBadges: [Badge]
    /// When the card should be reviewed next.
    public let nextReviewDate: Date
    /// The user's current daily streak.
    public let currentStreak: Int
}
