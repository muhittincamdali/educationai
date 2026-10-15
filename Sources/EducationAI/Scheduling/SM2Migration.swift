import Foundation

extension ReviewState {
    /// Converts an SM-2 item to an FSRS state that keeps its schedule and progress.
    ///
    /// Stability is chosen so that recall probability reaches `sm2Retention` after the item's
    /// current SM-2 interval, and difficulty so that the next successful review grows the interval
    /// by about the item's easiness factor. This is the conversion `fsrs-rs` (the FSRS
    /// implementation inside Anki) uses for cards without a complete review history.
    ///
    /// The item stays due when it was due; an item never reviewed under SM-2 becomes a new item.
    ///
    /// - Parameters:
    ///   - sm2: The item's SM-2 state.
    ///   - scheduler: The FSRS scheduler whose weights describe memory.
    ///   - sm2Retention: The share of reviews the learner passed under SM-2, between 0 and 1
    ///     (exclusive). 0.9 is typical.
    /// - Throws: ``SchedulingError/invalidState(_:)`` for SM-2 values no review could have
    ///   produced, ``SchedulingError/invalidConfiguration(_:)`` for a retention outside (0, 1).
    public init(migrating sm2: SM2State, scheduler: FSRSScheduler, sm2Retention: Double = 0.9) throws {
        try SM2Scheduler.validate(sm2)
        guard sm2Retention > 0, sm2Retention < 1 else {
            throw SchedulingError.invalidConfiguration("sm2Retention \(sm2Retention) not in (0, 1)")
        }
        guard sm2.interval > 0 || sm2.lastReview != nil else {
            self.init(due: sm2.due)
            return
        }
        let interval = Double(max(sm2.interval, 1))
        let weights = scheduler.weights
        let stability = scheduler.clampedStability(
            interval * scheduler.factor / (pow(sm2Retention, 1 / scheduler.decay) - 1)
        )
        let growth = exp(weights[8]) * pow(stability, -weights[9]) * expm1((1 - sm2Retention) * weights[10])
        let difficulty = 11 - (sm2.easeFactor - 1) / growth
        guard stability.isFinite, difficulty.isFinite else {
            throw SchedulingError.invalidState("the SM-2 values give no finite FSRS memory state")
        }
        let lastReview = sm2.lastReview ?? sm2.due.addingTimeInterval(-interval * .secondsPerDay)
        self.init(
            phase: .review, step: nil,
            stability: stability, difficulty: scheduler.clampedDifficulty(difficulty),
            due: sm2.due, lastReview: lastReview,
            reviewCount: sm2.repetitions, lapseCount: 0
        )
    }
}
