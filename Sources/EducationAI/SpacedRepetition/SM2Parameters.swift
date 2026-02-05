import Foundation

/// Tunable parameters for the SM-2 spaced repetition algorithm.
///
/// The SM-2 algorithm was originally described by Piotr Wozniak.
/// These parameters control how intervals grow, how the easiness factor
/// changes, and the minimum bounds.
public struct SM2Parameters: Sendable {

    /// Initial interval after the first successful review (in days).
    public var initialInterval: Double

    /// Second interval after two successful reviews (in days).
    public var secondInterval: Double

    /// Minimum easiness factor (prevents cards from becoming "too hard").
    public var minimumEasinessFactor: Double

    /// Default easiness factor for new cards.
    public var defaultEasinessFactor: Double

    /// Multiplier applied when the user rates "again" (lapse penalty).
    public var lapseMultiplier: Double

    /// Minimum interval in days (never schedule sooner than this).
    public var minimumInterval: Double

    /// Maximum interval in days (cap for very well-known cards).
    public var maximumInterval: Double

    /// How much a "hard" rating reduces the interval (0-1).
    public var hardIntervalFactor: Double

    /// How much an "easy" rating extends the interval beyond normal.
    public var easyBonus: Double

    public init(
        initialInterval: Double = 1.0,
        secondInterval: Double = 6.0,
        minimumEasinessFactor: Double = 1.3,
        defaultEasinessFactor: Double = 2.5,
        lapseMultiplier: Double = 0.5,
        minimumInterval: Double = 1.0,
        maximumInterval: Double = 365.0,
        hardIntervalFactor: Double = 0.8,
        easyBonus: Double = 1.3
    ) {
        self.initialInterval = initialInterval
        self.secondInterval = secondInterval
        self.minimumEasinessFactor = minimumEasinessFactor
        self.defaultEasinessFactor = defaultEasinessFactor
        self.lapseMultiplier = lapseMultiplier
        self.minimumInterval = minimumInterval
        self.maximumInterval = maximumInterval
        self.hardIntervalFactor = hardIntervalFactor
        self.easyBonus = easyBonus
    }

    /// Sensible defaults matching the original SM-2 paper.
    public static let `default` = SM2Parameters()
}
