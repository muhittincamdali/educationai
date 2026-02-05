import Foundation

/// Content recommendation engine that suggests what to study next.
///
/// Uses a scoring algorithm that considers:
/// - Cards due for review (spaced repetition)
/// - Weak areas (low accuracy subjects)
/// - Knowledge gaps (unreviewed content)
/// - Time since last study
///
/// ```swift
/// let engine = RecommendationEngine()
/// let recommendations = engine.recommend(
///     cards: allCards,
///     progress: learnerProgress,
///     limit: 5
/// )
/// ```
public struct RecommendationEngine: Sendable {

    public init() {}

    // MARK: - Public API

    /// Generate study recommendations sorted by priority.
    ///
    /// - Parameters:
    ///   - cards: All available flashcards.
    ///   - progress: Current learning progress.
    ///   - limit: Maximum recommendations to return.
    /// - Returns: Ordered list of ``Recommendation`` items.
    public func recommend(
        cards: [Flashcard],
        progress: LearningProgress,
        limit: Int = 10
    ) -> [Recommendation] {
        guard !cards.isEmpty else { return [] }

        var recommendations: [Recommendation] = []

        // 1. Overdue reviews (highest priority)
        let overdueCards = cards
            .filter { $0.isDue && !$0.isNew }
            .sorted { $0.nextReviewDate < $1.nextReviewDate }

        if !overdueCards.isEmpty {
            recommendations.append(Recommendation(
                type: .overdueReview,
                title: "Review overdue cards",
                description: "\(overdueCards.count) card(s) need review to maintain retention.",
                priority: .critical,
                cardIDs: overdueCards.prefix(20).map(\.id),
                estimatedMinutes: max(1, overdueCards.count / 2)
            ))
        }

        // 2. Weak subjects (subjects with accuracy < 60%)
        let weakSubjects = progress.subjects.values
            .filter { $0.accuracy < 0.6 && $0.reviewedCards > 5 }
            .sorted { $0.accuracy < $1.accuracy }

        for subject in weakSubjects.prefix(3) {
            let subjectCards = cards.filter { $0.subjectID == subject.subjectID }
            let weakCards = subjectCards
                .sorted { $0.accuracy < $1.accuracy }
                .prefix(10)

            recommendations.append(Recommendation(
                type: .weakArea,
                title: "Strengthen weak area",
                description: "Accuracy is \(Int(subject.accuracy * 100))%. Focus on these cards.",
                priority: .high,
                cardIDs: weakCards.map(\.id),
                subjectID: subject.subjectID,
                estimatedMinutes: max(2, weakCards.count)
            ))
        }

        // 3. New cards (unreviewed content)
        let newCards = cards
            .filter { $0.isNew }
            .sorted { $0.createdAt < $1.createdAt }

        if !newCards.isEmpty {
            // Group by subject
            let grouped = Dictionary(grouping: newCards, by: \.subjectID)
            for (subjectID, subjectNewCards) in grouped.prefix(3) {
                recommendations.append(Recommendation(
                    type: .newContent,
                    title: "Learn new material",
                    description: "\(subjectNewCards.count) new card(s) ready to learn.",
                    priority: .medium,
                    cardIDs: subjectNewCards.prefix(10).map(\.id),
                    subjectID: subjectID,
                    estimatedMinutes: max(2, subjectNewCards.count)
                ))
            }
        }

        // 4. Lapsed cards (previously known, now forgotten)
        let lapsedCards = cards.filter { $0.isLapsed }
        if !lapsedCards.isEmpty {
            recommendations.append(Recommendation(
                type: .lapsedReview,
                title: "Re-learn forgotten cards",
                description: "\(lapsedCards.count) card(s) need to be re-learned.",
                priority: .high,
                cardIDs: lapsedCards.prefix(15).map(\.id),
                estimatedMinutes: max(2, lapsedCards.count)
            ))
        }

        // 5. Subjects not studied recently (> 3 days)
        let threeDaysAgo = Date().addingTimeInterval(-3 * 86_400)
        let staleSubjects = progress.subjects.values
            .filter { ($0.lastStudied ?? .distantPast) < threeDaysAgo }
            .filter { $0.totalCards > 0 }

        for subject in staleSubjects.prefix(2) {
            let subjectCards = cards.filter { $0.subjectID == subject.subjectID }
            recommendations.append(Recommendation(
                type: .staleSubject,
                title: "Return to this subject",
                description: "You haven't studied this in a while. Time for a refresher!",
                priority: .low,
                cardIDs: subjectCards.prefix(10).map(\.id),
                subjectID: subject.subjectID,
                estimatedMinutes: 5
            ))
        }

        // Sort by priority and limit
        recommendations.sort { $0.priority.sortOrder < $1.priority.sortOrder }
        return Array(recommendations.prefix(limit))
    }
}

// MARK: - Recommendation

/// A single study recommendation.
public struct Recommendation: Identifiable, Sendable {
    public let id: UUID
    public let type: RecommendationType
    public var title: String
    public var description: String
    public var priority: RecommendationPriority
    public var cardIDs: [UUID]
    public var subjectID: UUID?
    public var estimatedMinutes: Int

    public init(
        id: UUID = UUID(),
        type: RecommendationType,
        title: String,
        description: String,
        priority: RecommendationPriority,
        cardIDs: [UUID] = [],
        subjectID: UUID? = nil,
        estimatedMinutes: Int = 5
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.description = description
        self.priority = priority
        self.cardIDs = cardIDs
        self.subjectID = subjectID
        self.estimatedMinutes = estimatedMinutes
    }
}

/// Category of study recommendation.
public enum RecommendationType: String, Sendable, CaseIterable {
    case overdueReview
    case weakArea
    case newContent
    case lapsedReview
    case staleSubject
}

/// Priority level for recommendations.
public enum RecommendationPriority: String, Sendable, CaseIterable, Comparable {
    case critical
    case high
    case medium
    case low

    var sortOrder: Int {
        switch self {
        case .critical: return 0
        case .high:     return 1
        case .medium:   return 2
        case .low:      return 3
        }
    }

    public static func < (lhs: RecommendationPriority, rhs: RecommendationPriority) -> Bool {
        lhs.sortOrder < rhs.sortOrder
    }
}
