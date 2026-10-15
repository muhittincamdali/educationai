import Foundation

/// Schedules reviews with FSRS-6, the Free Spaced Repetition Scheduler.
///
/// FSRS models each item's memory with a stability (how long it is remembered) and a difficulty,
/// and schedules the next review for the day recall probability is predicted to fall to
/// ``desiredRetention``. New and forgotten items first go through short learning or relearning
/// steps, as in Anki.
///
/// The results match `py-fsrs` 6.3.2, the reference implementation, for the same settings,
/// dates and ratings (interval fuzz aside, which is random by design).
///
/// ```swift
/// let scheduler = try FSRSScheduler()
/// var card = ReviewState()
/// let outcome = try scheduler.review(card, rating: .good)
/// card = outcome.state            // store this
/// print(outcome.interval)         // 600 seconds: the second learning step
/// ```
///
/// The scheduler is an immutable value: create it once and use it from any thread.
public struct FSRSScheduler: Sendable, Hashable {
    /// The 21 model weights. See ``FSRSWeights``.
    public let weights: [Double]
    /// The recall probability at which reviews are scheduled, between 0 and 1 (exclusive).
    public let desiredRetention: Double
    /// The waiting times of the learning steps for new items, in seconds.
    public let learningSteps: [TimeInterval]
    /// The waiting times of the relearning steps for forgotten items, in seconds.
    public let relearningSteps: [TimeInterval]
    /// The longest interval in days the scheduler gives a review item.
    public let maximumInterval: Int
    /// Whether review intervals of three days or more are spread by a few days at random, so that
    /// items learned together do not all come due on the same day.
    public let fuzzEnabled: Bool

    /// The largest allowed ``maximumInterval``: 100 years.
    public static let maximumIntervalLimit = 36_500

    /// A scheduler with the default settings: FSRS-6 default weights, 90 % desired retention,
    /// learning steps of 1 and 10 minutes, a relearning step of 10 minutes, a maximum interval of
    /// 100 years and fuzz on. Unlike the initializer it does not throw.
    public static let `default`: FSRSScheduler = {
        do { return try FSRSScheduler() } catch { preconditionFailure("The default settings are valid: \(error)") }
    }()

    /// Creates a scheduler.
    ///
    /// - Parameters:
    ///   - weights: 21 FSRS-6 weights, or 19 FSRS-5 weights. Defaults to ``FSRSWeights/defaults``.
    ///   - desiredRetention: Target recall probability, greater than 0 and less than 1. Higher
    ///     values mean shorter intervals and more reviews.
    ///   - learningSteps: Waiting times in seconds for new items before they become review items.
    ///     Each must be positive and at most 100 years. An empty array skips learning.
    ///   - relearningSteps: The same for forgotten items.
    ///   - maximumInterval: Longest review interval in days, from 1 to 36,500.
    ///   - fuzzEnabled: Whether to spread review intervals at random.
    /// - Throws: ``SchedulingError/invalidConfiguration(_:)`` when a value is out of range or NaN.
    public init(
        weights: [Double] = FSRSWeights.defaults,
        desiredRetention: Double = 0.9,
        learningSteps: [TimeInterval] = [60, 600],
        relearningSteps: [TimeInterval] = [600],
        maximumInterval: Int = 36_500,
        fuzzEnabled: Bool = true
    ) throws {
        self.weights = try FSRSWeights.validated(weights)
        guard desiredRetention > 0, desiredRetention < 1 else {
            throw SchedulingError.invalidConfiguration("desiredRetention \(desiredRetention) not in (0, 1)")
        }
        try Self.validateSteps(learningSteps, name: "learningSteps")
        try Self.validateSteps(relearningSteps, name: "relearningSteps")
        guard (1...Self.maximumIntervalLimit).contains(maximumInterval) else {
            throw SchedulingError.invalidConfiguration(
                "maximumInterval \(maximumInterval) not in 1...\(Self.maximumIntervalLimit)"
            )
        }
        self.desiredRetention = desiredRetention
        self.learningSteps = learningSteps
        self.relearningSteps = relearningSteps
        self.maximumInterval = maximumInterval
        self.fuzzEnabled = fuzzEnabled
    }

    private static func validateSteps(_ steps: [TimeInterval], name: String) throws {
        let limit = TimeInterval(maximumIntervalLimit) * .secondsPerDay
        for (index, step) in steps.enumerated() where !(step > 0 && step <= limit) {
            throw SchedulingError.invalidConfiguration("\(name)[\(index)] = \(step) not in (0, \(limit)] seconds")
        }
    }

    // MARK: - Reviewing

    /// Reviews an item and returns its new state.
    ///
    /// - Parameters:
    ///   - state: The item's current state.
    ///   - rating: How well the learner remembered the item.
    ///   - date: When the review happened. Defaults to now.
    ///   - duration: How long the learner took, in seconds, kept in the log only.
    /// - Throws: ``SchedulingError/invalidState(_:)`` for a state no review could have produced,
    ///   ``SchedulingError/invalidDate`` for a NaN or infinite date.
    public func review(
        _ state: ReviewState,
        rating: Rating,
        at date: Date = .now,
        duration: TimeInterval? = nil
    ) throws -> ReviewOutcome {
        var generator = SystemRandomNumberGenerator()
        return try review(state, rating: rating, at: date, duration: duration, using: &generator)
    }

    /// Reviews an item, drawing interval fuzz from `generator`.
    ///
    /// Use a ``SeededRandomNumberGenerator`` for reproducible intervals.
    public func review<Generator: RandomNumberGenerator>(
        _ state: ReviewState,
        rating: Rating,
        at date: Date = .now,
        duration: TimeInterval? = nil,
        using generator: inout Generator
    ) throws -> ReviewOutcome {
        guard SafeNumerics.isFinite(date) else { throw SchedulingError.invalidDate }
        try Self.validate(state)
        return transition(state, rating: rating, at: date, duration: duration, using: &generator)
    }

    /// The outcome of every rating, to show the next interval on each answer button.
    public func preview(_ state: ReviewState, at date: Date = .now) throws -> ReviewPreview {
        var generator = SystemRandomNumberGenerator()
        return try preview(state, at: date, using: &generator)
    }

    /// The outcome of every rating, drawing interval fuzz from `generator`.
    public func preview<Generator: RandomNumberGenerator>(
        _ state: ReviewState,
        at date: Date = .now,
        using generator: inout Generator
    ) throws -> ReviewPreview {
        ReviewPreview(
            again: try review(state, rating: .again, at: date, using: &generator),
            hard: try review(state, rating: .hard, at: date, using: &generator),
            good: try review(state, rating: .good, at: date, using: &generator),
            easy: try review(state, rating: .easy, at: date, using: &generator)
        )
    }

    /// The predicted probability, from 0 to 1, that the learner recalls the item at `date`.
    ///
    /// Elapsed time counts in whole days, as in FSRS. Returns 0 for an item that was never
    /// reviewed or whose stored values are not valid.
    public func retrievability(of state: ReviewState, at date: Date = .now) -> Double {
        guard let lastReview = state.lastReview, let stability = state.stability,
              stability > 0, stability.isFinite,
              SafeNumerics.isFinite(lastReview), SafeNumerics.isFinite(date)
        else { return 0 }
        return forgettingCurve(elapsedDays: max(0, Self.elapsedDays(from: lastReview, to: date)), stability: stability)
    }

    /// Replays a review history from a new item, for example after changing the weights or the
    /// desired retention, or to import reviews made in another app.
    ///
    /// - Parameters:
    ///   - logs: The item's reviews, in any order; they are sorted by date.
    ///   - generator: The source of interval fuzz.
    /// - Returns: The state after the last review, or a new item due at the earliest review date
    ///   when `logs` is empty.
    public func replay<Generator: RandomNumberGenerator>(
        _ logs: [ReviewLog],
        using generator: inout Generator
    ) throws -> ReviewState {
        let sorted = logs.sorted { $0.reviewedAt < $1.reviewedAt }
        var state = ReviewState(due: sorted.first?.reviewedAt ?? .now)
        for log in sorted {
            state = try review(state, rating: log.rating, at: log.reviewedAt, duration: log.duration, using: &generator).state
        }
        return state
    }

    /// Replays a review history with system randomness for fuzz. See ``replay(_:using:)``.
    public func replay(_ logs: [ReviewLog]) throws -> ReviewState {
        var generator = SystemRandomNumberGenerator()
        return try replay(logs, using: &generator)
    }
}

// MARK: - Codable

extension FSRSScheduler: Codable {
    private enum CodingKeys: String, CodingKey {
        case weights, desiredRetention, learningSteps, relearningSteps, maximumInterval, fuzzEnabled
    }

    /// Decodes a scheduler and checks every setting, as the initializer does.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(
            weights: try container.decode([Double].self, forKey: .weights),
            desiredRetention: try container.decode(Double.self, forKey: .desiredRetention),
            learningSteps: try container.decode([TimeInterval].self, forKey: .learningSteps),
            relearningSteps: try container.decode([TimeInterval].self, forKey: .relearningSteps),
            maximumInterval: try container.decode(Int.self, forKey: .maximumInterval),
            fuzzEnabled: try container.decode(Bool.self, forKey: .fuzzEnabled)
        )
    }

    /// Encodes the settings.
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(weights, forKey: .weights)
        try container.encode(desiredRetention, forKey: .desiredRetention)
        try container.encode(learningSteps, forKey: .learningSteps)
        try container.encode(relearningSteps, forKey: .relearningSteps)
        try container.encode(maximumInterval, forKey: .maximumInterval)
        try container.encode(fuzzEnabled, forKey: .fuzzEnabled)
    }
}
