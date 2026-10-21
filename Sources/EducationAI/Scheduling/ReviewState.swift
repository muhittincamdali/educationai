import Foundation

/// The memory state and schedule of one item, as kept by ``FSRSScheduler``.
///
/// Store one `ReviewState` next to each of your items (a flashcard, a word, a question) and
/// replace it with the state a review returns. It is `Codable`, so it fits in a JSON file, a
/// SwiftData attribute or a database column. A new item starts as `ReviewState()`, due now.
///
/// ```swift
/// var card = ReviewState()
/// card = try scheduler.review(card, rating: .good).state
/// print(card.due)
/// ```
public struct ReviewState: Codable, Sendable, Hashable {
    /// Where an item is in its learning cycle.
    public enum Phase: String, Codable, Sendable, Hashable, CaseIterable {
        /// A new item going through the short learning steps.
        case learning
        /// A learned item scheduled days or more ahead.
        case review
        /// A forgotten review item going through the short relearning steps.
        case relearning
    }

    /// Where the item is in its learning cycle.
    public internal(set) var phase: Phase
    /// The index of the current learning or relearning step; `nil` in the review phase.
    public internal(set) var step: Int?
    /// The number of days after which recall probability falls to 90 %; `nil` before the first review.
    public internal(set) var stability: Double?
    /// How hard the item is to remember, from 1 (easiest) to 10; `nil` before the first review.
    public internal(set) var difficulty: Double?
    /// When the item should be shown next.
    public internal(set) var due: Date
    /// When the item was last reviewed; `nil` before the first review.
    public internal(set) var lastReview: Date?
    /// How many times the item has been reviewed.
    public internal(set) var reviewCount: Int
    /// How many times the item was forgotten in the review phase.
    public internal(set) var lapseCount: Int

    /// A new item that has never been reviewed, due at `due`.
    public init(due: Date = .now) {
        self.init(
            phase: .learning, step: 0, stability: nil, difficulty: nil,
            due: due, lastReview: nil, reviewCount: 0, lapseCount: 0
        )
    }

    /// Restores a state from values you stored yourself, for example in separate database columns.
    ///
    /// The values are checked when the state is next reviewed: ``FSRSScheduler/review(_:rating:at:duration:)``
    /// throws ``SchedulingError/invalidState(_:)`` for values that no review could have produced.
    public init(
        phase: Phase,
        step: Int?,
        stability: Double?,
        difficulty: Double?,
        due: Date,
        lastReview: Date?,
        reviewCount: Int,
        lapseCount: Int
    ) {
        self.phase = phase
        self.step = step
        self.stability = stability
        self.difficulty = difficulty
        self.due = due
        self.lastReview = lastReview
        self.reviewCount = reviewCount
        self.lapseCount = lapseCount
    }

    /// Whether the item has never been reviewed, or was reset with ``reset(dueAt:keepingCounts:)``.
    public var isNew: Bool { lastReview == nil }

    /// Whether the item is due at `date`.
    public func isDue(at date: Date = .now) -> Bool { due <= date }

    /// The item as a new one again, for a "forget" or "reset" action when it is to be learned
    /// from scratch.
    ///
    /// The memory state is dropped, so the next review starts the learning steps exactly as for a
    /// card never seen, and ``StudyQueue`` counts the item as new. To undo a single review
    /// instead, store the state from before it again: states are values, so the old one is
    /// still the right one.
    ///
    /// ```swift
    /// card.review = card.review.reset(dueAt: .now)
    /// ```
    ///
    /// - Parameters:
    ///   - due: When the item is due again. Defaults to now.
    ///   - keepingCounts: Whether ``reviewCount`` and ``lapseCount`` keep their values, for
    ///     statistics. By default both start again at 0.
    public func reset(dueAt due: Date = .now, keepingCounts: Bool = false) -> ReviewState {
        var state = ReviewState(due: due)
        if keepingCounts {
            state.reviewCount = reviewCount
            state.lapseCount = lapseCount
        }
        return state
    }
}

/// A record of one review, kept to compute statistics or to replay a history with other settings.
public struct ReviewLog: Codable, Sendable, Hashable {
    /// The rating the learner chose.
    public let rating: Rating
    /// When the review happened.
    public let reviewedAt: Date
    /// The item's phase before the review.
    public let phase: ReviewState.Phase
    /// The time until the next review that this review scheduled, in seconds.
    public let scheduledInterval: TimeInterval
    /// How long the learner took to answer, in seconds, if you measured it.
    public let duration: TimeInterval?

    /// Creates a log entry, for example to import a review history from another app.
    public init(
        rating: Rating,
        reviewedAt: Date,
        phase: ReviewState.Phase,
        scheduledInterval: TimeInterval,
        duration: TimeInterval? = nil
    ) {
        self.rating = rating
        self.reviewedAt = reviewedAt
        self.phase = phase
        self.scheduledInterval = scheduledInterval
        self.duration = duration
    }
}

/// The result of reviewing an item: its new state and the log entry for the review.
public struct ReviewOutcome: Sendable, Hashable {
    /// The item's state after the review. Store it in place of the previous state.
    public let state: ReviewState
    /// The log entry describing the review.
    public let log: ReviewLog

    /// The time from the review until the item is due again, in seconds.
    public var interval: TimeInterval { log.scheduledInterval }
}

/// The outcome each rating would have, for showing the next interval on each answer button.
///
/// Store the outcome of the rating the learner picks; it is the same result a review with that
/// rating at the same time would give, including any interval fuzz.
public struct ReviewPreview: Sendable, Hashable {
    /// The outcome of rating the item ``Rating/again``.
    public let again: ReviewOutcome
    /// The outcome of rating the item ``Rating/hard``.
    public let hard: ReviewOutcome
    /// The outcome of rating the item ``Rating/good``.
    public let good: ReviewOutcome
    /// The outcome of rating the item ``Rating/easy``.
    public let easy: ReviewOutcome

    /// The outcome for `rating`.
    public subscript(rating: Rating) -> ReviewOutcome {
        switch rating {
        case .again: again
        case .hard: hard
        case .good: good
        case .easy: easy
        }
    }
}
