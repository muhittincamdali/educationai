import Foundation

extension FSRSScheduler {
    /// Rejects stored states that no review could have produced, before any arithmetic runs on them.
    static func validate(_ state: ReviewState) throws {
        func invalid(_ message: String) -> SchedulingError { .invalidState(message) }
        guard SafeNumerics.isFinite(state.due) else { throw invalid("due is not finite") }
        if let lastReview = state.lastReview, !SafeNumerics.isFinite(lastReview) {
            throw invalid("lastReview is not finite")
        }
        guard state.reviewCount >= 0, state.lapseCount >= 0 else { throw invalid("negative review or lapse count") }
        switch (state.stability, state.difficulty) {
        case (nil, nil):
            guard state.phase == .learning else { throw invalid("\(state.phase) phase without stability and difficulty") }
        case let (stability?, difficulty?):
            guard stability.isFinite, stability > 0 else { throw invalid("stability \(stability) is not a positive number") }
            guard FSRSWeights.difficultyRange.contains(difficulty) else {
                throw invalid("difficulty \(difficulty) not in \(FSRSWeights.difficultyRange)")
            }
        default:
            throw invalid("stability and difficulty must both be set or both be nil")
        }
        switch state.phase {
        case .learning, .relearning:
            guard let step = state.step, step >= 0 else { throw invalid("\(state.phase) phase needs a step of 0 or more") }
        case .review:
            guard state.step == nil else { throw invalid("review phase has a step") }
        }
    }

    /// The FSRS state machine. `state` has been validated.
    func transition<Generator: RandomNumberGenerator>(
        _ state: ReviewState,
        rating: Rating,
        at date: Date,
        duration: TimeInterval?,
        using generator: inout Generator
    ) -> ReviewOutcome {
        var next = state
        updateMemory(&next, rating: rating, at: date)

        let interval: TimeInterval
        switch state.phase {
        case .learning:
            interval = advanceSteps(&next, steps: learningSteps, rating: rating)
        case .relearning:
            interval = advanceSteps(&next, steps: relearningSteps, rating: rating)
        case .review:
            if rating == .again {
                next.lapseCount = SafeNumerics.incremented(next.lapseCount)
                if relearningSteps.isEmpty {
                    interval = graduate(&next)
                } else {
                    next.phase = .relearning
                    next.step = 0
                    interval = relearningSteps[0]
                }
            } else {
                interval = graduate(&next)
            }
        }

        let scheduled = fuzzed(interval, phase: next.phase, using: &generator)
        next.due = date.addingTimeInterval(scheduled)
        next.lastReview = date
        next.reviewCount = SafeNumerics.incremented(next.reviewCount)
        let log = ReviewLog(rating: rating, reviewedAt: date, phase: state.phase, scheduledInterval: scheduled, duration: duration)
        return ReviewOutcome(state: next, log: log)
    }

    /// Updates stability and difficulty. Reviews on the same day as the previous one use the
    /// short-term formula; in the review phase difficulty changes on every review.
    private func updateMemory(_ state: inout ReviewState, rating: Rating, at date: Date) {
        guard let stability = state.stability, let difficulty = state.difficulty else {
            state.stability = initialStability(rating)
            state.difficulty = initialDifficulty(rating, clamp: true)
            return
        }
        let elapsed = state.lastReview.map { Self.elapsedDays(from: $0, to: date) }
        if let elapsed, elapsed < 1 {
            state.stability = shortTermStability(stability, rating: rating)
        } else {
            state.stability = nextStability(
                difficulty: difficulty,
                stability: stability,
                retrievability: retrievability(of: state, at: date),
                rating: rating
            )
        }
        state.difficulty = nextDifficulty(difficulty, rating: rating)
    }

    /// Moves a learning or relearning item through `steps` and returns the waiting time.
    private func advanceSteps(_ state: inout ReviewState, steps: [TimeInterval], rating: Rating) -> TimeInterval {
        let step = state.step ?? 0
        if steps.isEmpty || (step >= steps.count && rating.isSuccessfulRecall) {
            return graduate(&state)
        }
        switch rating {
        case .again:
            state.step = 0
            return steps[0]
        case .hard:
            if step == 0 { return steps.count == 1 ? steps[0] * 1.5 : (steps[0] + steps[1]) / 2 }
            return steps[step]
        case .good:
            if step + 1 == steps.count { return graduate(&state) }
            state.step = step + 1
            return steps[step + 1]
        case .easy:
            return graduate(&state)
        }
    }

    /// Moves the item to the review phase and returns its interval.
    private func graduate(_ state: inout ReviewState) -> TimeInterval {
        state.phase = .review
        state.step = nil
        let days = nextIntervalDays(stability: state.stability ?? FSRSWeights.minimumStability)
        return TimeInterval(days) * .secondsPerDay
    }

    private func fuzzed<Generator: RandomNumberGenerator>(
        _ interval: TimeInterval,
        phase: ReviewState.Phase,
        using generator: inout Generator
    ) -> TimeInterval {
        guard fuzzEnabled, phase == .review else { return interval }
        let days = Int((interval / .secondsPerDay).rounded(.down))
        return TimeInterval(fuzzedIntervalDays(days, using: &generator)) * .secondsPerDay
    }
}
