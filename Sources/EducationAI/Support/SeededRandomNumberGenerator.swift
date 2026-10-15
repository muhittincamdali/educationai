/// A small, fast random number generator that produces the same sequence for the same seed.
///
/// Pass it to the APIs that take a generator (interval fuzz in ``FSRSScheduler``, choice order in
/// ``QuizBuilder``) when a result must be reproducible: in tests, in previews and screenshots, or
/// to give every learner the same quiz for a given day. It implements SplitMix64, which is not
/// suitable for cryptography.
///
/// ```swift
/// var generator = SeededRandomNumberGenerator(seed: 42)
/// let outcome = try scheduler.review(state, rating: .good, at: now, using: &generator)
/// ```
public struct SeededRandomNumberGenerator: RandomNumberGenerator, Sendable, Hashable, Codable {
    private var state: UInt64

    /// Creates a generator whose sequence is determined by `seed`.
    public init(seed: UInt64) {
        state = seed
    }

    /// Returns the next value of the sequence.
    public mutating func next() -> UInt64 {
        state &+= 0x9E37_79B9_7F4A_7C15
        var value = state
        value = (value ^ (value >> 30)) &* 0xBF58_476D_1CE4_E5B9
        value = (value ^ (value >> 27)) &* 0x94D0_49BB_1331_11EB
        return value ^ (value >> 31)
    }
}
