import Foundation

// The FSRS-6 formulas, written to follow py-fsrs 6.3.2 operation by operation. `pow(M_E, x)`
// stands for Python's `math.e ** x` (rather than `exp(x)`) so that results agree bit for bit and
// intervals that land on .5 days round the same way.
extension FSRSScheduler {
    var decay: Double { -weights[20] }

    var factor: Double { pow(0.9, 1 / decay) - 1 }

    /// Whole days between two finite dates, rounded down like Python's `timedelta.days`.
    /// Kept as a `Double`: the difference of two far-apart dates can exceed `Int`'s range.
    static func elapsedDays(from start: Date, to end: Date) -> Double {
        (end.timeIntervalSince(start) / .secondsPerDay).rounded(.down)
    }

    func forgettingCurve(elapsedDays: Double, stability: Double) -> Double {
        pow(1 + factor * elapsedDays / stability, decay)
    }

    func clampedDifficulty(_ difficulty: Double) -> Double {
        min(max(difficulty, FSRSWeights.difficultyRange.lowerBound), FSRSWeights.difficultyRange.upperBound)
    }

    func clampedStability(_ stability: Double) -> Double {
        min(max(stability, FSRSWeights.minimumStability), FSRSWeights.maximumStability)
    }

    func initialStability(_ rating: Rating) -> Double {
        clampedStability(weights[rating.rawValue - 1])
    }

    func initialDifficulty(_ rating: Rating, clamp: Bool) -> Double {
        let difficulty = weights[4] - pow(M_E, weights[5] * Double(rating.rawValue - 1)) + 1
        return clamp ? clampedDifficulty(difficulty) : difficulty
    }

    /// The review interval in whole days for a stability, between 1 and ``maximumInterval``.
    func nextIntervalDays(stability: Double) -> Int {
        let days = (stability / factor) * (pow(desiredRetention, 1 / decay) - 1)
        return SafeNumerics.roundedInt(days, clampedTo: 1...maximumInterval)
    }

    func shortTermStability(_ stability: Double, rating: Rating) -> Double {
        var increase = pow(M_E, weights[17] * (Double(rating.rawValue) - 3 + weights[18]))
            * pow(stability, -weights[19])
        if rating.isSuccessfulRecall { increase = max(increase, 1) }
        return clampedStability(stability * increase)
    }

    func nextDifficulty(_ difficulty: Double, rating: Rating) -> Double {
        let delta = -(weights[6] * (Double(rating.rawValue) - 3))
        let damped = difficulty + (10 - difficulty) * delta / 9
        let target = initialDifficulty(.easy, clamp: false)
        return clampedDifficulty(weights[7] * target + (1 - weights[7]) * damped)
    }

    func nextStability(difficulty: Double, stability: Double, retrievability: Double, rating: Rating) -> Double {
        let next = rating == .again
            ? forgetStability(difficulty: difficulty, stability: stability, retrievability: retrievability)
            : recallStability(difficulty: difficulty, stability: stability, retrievability: retrievability, rating: rating)
        return clampedStability(next)
    }

    private func forgetStability(difficulty: Double, stability: Double, retrievability: Double) -> Double {
        let longTerm = weights[11]
            * pow(difficulty, -weights[12])
            * (pow(stability + 1, weights[13]) - 1)
            * pow(M_E, (1 - retrievability) * weights[14])
        let shortTerm = stability / pow(M_E, weights[17] * weights[18])
        return min(longTerm, shortTerm)
    }

    private func recallStability(difficulty: Double, stability: Double, retrievability: Double, rating: Rating) -> Double {
        let hardPenalty = rating == .hard ? weights[15] : 1
        let easyBonus = rating == .easy ? weights[16] : 1
        return stability * (
            1 + pow(M_E, weights[8])
                * (11 - difficulty)
                * pow(stability, -weights[9])
                * (pow(M_E, (1 - retrievability) * weights[10]) - 1)
                * hardPenalty
                * easyBonus
        )
    }

    /// Spreads a review interval of three days or more over a range that grows with its length.
    func fuzzedIntervalDays<Generator: RandomNumberGenerator>(_ days: Int, using generator: inout Generator) -> Int {
        guard Double(days) >= 2.5 else { return days }
        let ranges: [(start: Double, end: Double, factor: Double)] = [(2.5, 7, 0.15), (7, 20, 0.1), (20, .infinity, 0.05)]
        var delta = 1.0
        for range in ranges {
            delta += range.factor * max(min(Double(days), range.end) - range.start, 0)
        }
        let upper = min(SafeNumerics.roundedInt(Double(days) + delta, clampedTo: 1...maximumInterval), maximumInterval)
        let lower = min(max(2, SafeNumerics.roundedInt(Double(days) - delta, clampedTo: 1...maximumInterval)), upper)
        let draw = Double.random(in: 0..<1, using: &generator) * Double(upper - lower + 1) + Double(lower)
        return SafeNumerics.roundedInt(draw, clampedTo: 1...maximumInterval)
    }
}
