import Foundation

/// SM-2 based spaced repetition scheduler.
///
/// Calculates the next review date and updates the easiness factor
/// for each flashcard based on the learner's self-reported recall quality.
///
/// ```swift
/// let scheduler = SpacedRepetitionScheduler()
/// let updated = scheduler.review(card: card, rating: .good)
/// print("Next review:", updated.nextReviewDate)
/// ```
///
/// The algorithm is a refined variant of SuperMemo 2 (SM-2):
/// 1. If the learner answers correctly (quality ≥ 3):
///    - First repetition: interval = 1 day
///    - Second repetition: interval = 6 days
///    - Subsequent: interval = previous × easiness factor
/// 2. If the learner forgets (quality < 3):
///    - Reset repetition count to 0
///    - Reduce interval by lapse multiplier
/// 3. Easiness factor is adjusted after every review.
public struct SpacedRepetitionScheduler: Sendable {

    /// Algorithm parameters.
    public let parameters: SM2Parameters

    public init(parameters: SM2Parameters = .default) {
        self.parameters = parameters
    }

    // MARK: - Public API

    /// Review a flashcard and return the updated card with new schedule.
    ///
    /// - Parameters:
    ///   - card: The flashcard being reviewed.
    ///   - rating: The learner's self-reported recall quality.
    /// - Returns: An updated copy of the card with adjusted interval and next review date.
    public func review(card: Flashcard, rating: RecallRating) -> Flashcard {
        var updated = card
        let quality = rating.sm2Quality

        // Update easiness factor using SM-2 formula
        let ef = card.easinessFactor + (0.1 - Double(5 - quality) * (0.08 + Double(5 - quality) * 0.02))
        updated.easinessFactor = max(parameters.minimumEasinessFactor, ef)

        // Update statistics
        updated.totalReviews += 1
        updated.lastReviewDate = Date()

        if rating.isCorrect {
            updated.correctCount += 1
            updated.repetitionCount += 1

            // Calculate new interval
            switch updated.repetitionCount {
            case 1:
                updated.intervalDays = parameters.initialInterval
            case 2:
                updated.intervalDays = parameters.secondInterval
            default:
                updated.intervalDays = card.intervalDays * updated.easinessFactor
            }

            // Apply easy bonus
            if rating == .easy {
                updated.intervalDays *= parameters.easyBonus
            }

        } else {
            // Lapse: reset repetition count, shrink interval
            updated.repetitionCount = 0

            if rating == .hard {
                updated.intervalDays = max(
                    parameters.minimumInterval,
                    card.intervalDays * parameters.hardIntervalFactor
                )
            } else {
                // "Again" — significant reduction
                updated.intervalDays = max(
                    parameters.minimumInterval,
                    card.intervalDays * parameters.lapseMultiplier
                )
            }
        }

        // Clamp interval
        updated.intervalDays = min(updated.intervalDays, parameters.maximumInterval)
        updated.intervalDays = max(updated.intervalDays, parameters.minimumInterval)

        // Set next review date
        updated.nextReviewDate = Calendar.current.date(
            byAdding: .second,
            value: Int(updated.intervalDays * 86_400),
            to: Date()
        ) ?? Date().addingTimeInterval(updated.intervalDays * 86_400)

        return updated
    }

    /// Calculate the projected next review dates for every rating option.
    ///
    /// Useful for showing the learner what each button will do.
    ///
    /// - Parameter card: The card being reviewed.
    /// - Returns: Dictionary mapping each ``RecallRating`` to its projected next review date.
    public func previewIntervals(for card: Flashcard) -> [RecallRating: TimeInterval] {
        var result: [RecallRating: TimeInterval] = [:]
        for rating in RecallRating.allCases {
            let projected = review(card: card, rating: rating)
            result[rating] = projected.intervalDays * 86_400
        }
        return result
    }

    /// Get cards that are due for review, sorted by urgency.
    ///
    /// - Parameters:
    ///   - cards: All available flashcards.
    ///   - limit: Maximum number of cards to return.
    /// - Returns: Due cards sorted by overdue-ness (most overdue first).
    public func dueCards(from cards: [Flashcard], limit: Int? = nil) -> [Flashcard] {
        let now = Date()
        var due = cards.filter { $0.nextReviewDate <= now }
        due.sort { $0.nextReviewDate < $1.nextReviewDate }
        if let limit = limit {
            return Array(due.prefix(limit))
        }
        return due
    }

    /// Get new cards that have never been reviewed, in creation order.
    ///
    /// - Parameters:
    ///   - cards: All available flashcards.
    ///   - limit: Maximum number of cards to return.
    /// - Returns: New cards sorted by creation date.
    public func newCards(from cards: [Flashcard], limit: Int? = nil) -> [Flashcard] {
        var fresh = cards.filter { $0.isNew }
        fresh.sort { $0.createdAt < $1.createdAt }
        if let limit = limit {
            return Array(fresh.prefix(limit))
        }
        return fresh
    }

    /// Build a study queue combining due reviews and new cards.
    ///
    /// - Parameters:
    ///   - cards: All available flashcards.
    ///   - maxNew: Maximum new cards to include.
    ///   - maxReview: Maximum review cards to include.
    /// - Returns: Ordered study queue (reviews first, then new).
    public func studyQueue(
        from cards: [Flashcard],
        maxNew: Int = 20,
        maxReview: Int = 100
    ) -> [Flashcard] {
        let reviews = dueCards(from: cards, limit: maxReview)
        let news = newCards(from: cards, limit: maxNew)
        return reviews + news
    }
}
