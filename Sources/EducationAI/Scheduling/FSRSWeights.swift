/// The 21 model weights of FSRS-6, with the defaults and the ranges each weight may take.
///
/// The defaults and the bounds are those of the reference implementation `py-fsrs` 6.3.2. Weights
/// trained for your learners with an FSRS optimizer (for example Anki's) can be passed to
/// ``FSRSScheduler/init(weights:desiredRetention:learningSteps:relearningSteps:maximumInterval:fuzzEnabled:)``
/// as they are.
public enum FSRSWeights {
    /// The FSRS-6 default weights.
    public static let defaults: [Double] = [
        0.212, 1.2931, 2.3065, 8.2956, 6.4133, 0.8334, 3.0194, 0.001, 1.8722, 0.1666, 0.796,
        1.4835, 0.0614, 0.2629, 1.6483, 0.6014, 1.8729, 0.5425, 0.0912, 0.0658, 0.1542
    ]

    /// The decay FSRS-5 used, appended when a 19-weight FSRS-5 set is upgraded.
    public static let fsrs5Decay = 0.5

    /// The smallest stability the scheduler produces, in days.
    public static let minimumStability = 0.001

    /// The range of difficulty values.
    public static let difficultyRange: ClosedRange<Double> = 1...10

    /// The allowed range of each weight, in order.
    public static let bounds: [ClosedRange<Double>] = [
        minimumStability...100, minimumStability...100, minimumStability...100, minimumStability...100,
        1...10, 0.001...4, 0.001...4, 0.001...0.75, 0...4.5, 0...0.8, 0.001...3.5,
        0.001...5, 0.001...0.25, 0.001...0.9, 0...4, 0...1, 1...6, 0...2, 0...2, 0...0.8, 0.1...0.8
    ]

    /// Checks `weights` and returns the 21 weights the scheduler uses.
    ///
    /// A 19-weight FSRS-5 set is accepted and extended with `0` and ``fsrs5Decay``, the values for
    /// which the FSRS-6 formulas give FSRS-5's long-term behavior (the same upgrade `ts-fsrs` does).
    static func validated(_ weights: [Double]) throws -> [Double] {
        var weights = weights
        if weights.count == 19 { weights += [0, fsrs5Decay] }
        guard weights.count == bounds.count else {
            throw SchedulingError.invalidConfiguration(
                "expected \(bounds.count) weights (or 19 from FSRS-5), got \(weights.count)"
            )
        }
        // `contains` is false for NaN, so NaN weights are rejected here too.
        let outOfBounds = weights.indices.filter { !bounds[$0].contains(weights[$0]) }
        guard outOfBounds.isEmpty else {
            let list = outOfBounds.map { "w[\($0)] = \(weights[$0]) not in \(bounds[$0])" }
            throw SchedulingError.invalidConfiguration(list.joined(separator: "; "))
        }
        return weights
    }
}
