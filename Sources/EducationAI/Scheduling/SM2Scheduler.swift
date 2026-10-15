import Foundation

/// The schedule of one item under the SM-2 algorithm.
public struct SM2State: Codable, Sendable, Hashable {
    /// The easiness factor, 1.3 or more. New items start at 2.5.
    public internal(set) var easeFactor: Double
    /// The number of successful reviews in a row.
    public internal(set) var repetitions: Int
    /// The current interval in days.
    public internal(set) var interval: Int
    /// When the item should be shown next.
    public internal(set) var due: Date
    /// When the item was last reviewed; `nil` before the first review.
    public internal(set) var lastReview: Date?

    /// A new item, due at `due`.
    public init(due: Date = .now) {
        self.init(easeFactor: SM2Scheduler.initialEaseFactor, repetitions: 0, interval: 0, due: due, lastReview: nil)
    }

    /// Restores a state from stored values, for example from another app's SM-2 data.
    ///
    /// The values are checked when the state is next reviewed or migrated.
    public init(easeFactor: Double, repetitions: Int, interval: Int, due: Date, lastReview: Date?) {
        self.easeFactor = easeFactor
        self.repetitions = repetitions
        self.interval = interval
        self.due = due
        self.lastReview = lastReview
    }
}

/// Schedules reviews with SM-2, the SuperMemo 2 algorithm used by many flashcard apps since 1987.
///
/// Use it to keep data from an SM-2 app working as it did; for new apps ``FSRSScheduler`` needs
/// fewer reviews for the same retention. ``ReviewState/init(migrating:scheduler:sm2Retention:)``
/// moves an SM-2 item to FSRS without losing its progress.
///
/// Each review takes a quality from 0 to 5. A quality below 3 restarts the item at one day; from
/// 3 up the interval goes 1 day, 6 days, then the previous interval times the easiness factor.
public struct SM2Scheduler: Sendable, Hashable, Codable {
    /// The easiness factor of a new item.
    public static let initialEaseFactor = 2.5
    /// The lowest easiness factor.
    public static let minimumEaseFactor = 1.3

    /// The longest interval in days, from 1 to 36,500.
    public let maximumInterval: Int

    /// Creates a scheduler.
    /// - Throws: ``SchedulingError/invalidConfiguration(_:)`` when `maximumInterval` is out of range.
    public init(maximumInterval: Int = 36_500) throws {
        guard (1...FSRSScheduler.maximumIntervalLimit).contains(maximumInterval) else {
            throw SchedulingError.invalidConfiguration("maximumInterval \(maximumInterval) not in 1...\(FSRSScheduler.maximumIntervalLimit)")
        }
        self.maximumInterval = maximumInterval
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(maximumInterval: try container.decode(Int.self, forKey: .maximumInterval))
    }

    /// The SM-2 quality for a rating: again 1, hard 3, good 4, easy 5.
    public static func quality(for rating: Rating) -> Int {
        switch rating {
        case .again: 1
        case .hard: 3
        case .good: 4
        case .easy: 5
        }
    }

    /// Reviews an item with a rating, converted with ``quality(for:)``.
    public func review(_ state: SM2State, rating: Rating, at date: Date = .now) throws -> SM2State {
        try review(state, quality: Self.quality(for: rating), at: date)
    }

    /// Reviews an item with an SM-2 quality from 0 (no recall) to 5 (perfect recall).
    /// - Throws: ``SchedulingError/invalidState(_:)`` for a quality outside 0...5 or stored values
    ///   no review could have produced, ``SchedulingError/invalidDate`` for a NaN or infinite date.
    public func review(_ state: SM2State, quality: Int, at date: Date = .now) throws -> SM2State {
        guard SafeNumerics.isFinite(date) else { throw SchedulingError.invalidDate }
        guard (0...5).contains(quality) else { throw SchedulingError.invalidState("quality \(quality) not in 0...5") }
        try Self.validate(state)

        var next = state
        if quality >= 3 {
            switch state.repetitions {
            case 0: next.interval = 1
            case 1: next.interval = 6
            default:
                let days = Double(max(state.interval, 1)) * state.easeFactor
                next.interval = SafeNumerics.roundedInt(days, clampedTo: 1...maximumInterval)
            }
            next.repetitions = SafeNumerics.incremented(state.repetitions)
        } else {
            next.repetitions = 0
            next.interval = 1
        }
        next.interval = min(next.interval, maximumInterval)
        let miss = Double(5 - quality)
        next.easeFactor = max(Self.minimumEaseFactor, state.easeFactor + (0.1 - miss * (0.08 + miss * 0.02)))
        next.lastReview = date
        next.due = date.addingTimeInterval(TimeInterval(next.interval) * .secondsPerDay)
        return next
    }

    static func validate(_ state: SM2State) throws {
        guard state.easeFactor.isFinite, state.easeFactor >= minimumEaseFactor else {
            throw SchedulingError.invalidState("easeFactor \(state.easeFactor) is not a number of at least \(minimumEaseFactor)")
        }
        guard state.repetitions >= 0, state.interval >= 0 else {
            throw SchedulingError.invalidState("negative repetitions or interval")
        }
        guard SafeNumerics.isFinite(state.due), state.lastReview.map(SafeNumerics.isFinite) ?? true else {
            throw SchedulingError.invalidState("due or lastReview is not finite")
        }
    }
}
