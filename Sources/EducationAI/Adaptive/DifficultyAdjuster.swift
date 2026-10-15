/// Raises or lowers a difficulty level to keep the learner's accuracy inside a target band.
///
/// Record each answer; when the accuracy over the last answers rises above the band, the level
/// goes up, and when it falls below, the level goes down. After a change the window starts
/// over, so one lucky streak does not move the level twice.
///
/// ```swift
/// var adjuster = try DifficultyAdjuster(levels: 1...5)
/// let change = adjuster.record(correct: true)
/// let questions = bank.filter { $0.level == adjuster.level }
/// ```
///
/// The default band, 70 to 85 percent, keeps learners challenged without discouraging them.
/// It is a `Codable` value, so the level and recent answers can be saved between sessions.
public struct DifficultyAdjuster: Codable, Sendable, Hashable {
    /// What the last recorded answer did to the level.
    public enum Change: Sendable, Hashable {
        case raised, lowered, unchanged
    }

    /// The largest window allowed.
    public static let maximumWindowSize = 1_000

    /// The levels the adjuster moves between.
    public let levels: ClosedRange<Int>
    /// The accuracy band to keep the learner in, within 0...1.
    public let targetAccuracy: ClosedRange<Double>
    /// How many recent answers the accuracy is computed over.
    public let windowSize: Int
    /// How many answers are needed in the window before the level can change.
    public let minimumAnswers: Int
    /// The current level.
    public private(set) var level: Int
    /// The answers in the current window, oldest first.
    public private(set) var recentAnswers: [Bool]

    /// Creates an adjuster.
    ///
    /// - Parameters:
    ///   - levels: The levels to move between.
    ///   - startingLevel: The first level; defaults to the middle of `levels`.
    ///   - targetAccuracy: The band to keep accuracy in, within 0...1.
    ///   - windowSize: Recent answers to consider, from 1 to ``maximumWindowSize``.
    ///   - minimumAnswers: Answers needed before a change, from 1 to `windowSize`.
    /// - Throws: ``AdaptiveError/invalidConfiguration(_:)`` when a value is out of range.
    public init(
        levels: ClosedRange<Int> = 1...5,
        startingLevel: Int? = nil,
        targetAccuracy: ClosedRange<Double> = 0.70...0.85,
        windowSize: Int = 10,
        minimumAnswers: Int = 5
    ) throws {
        guard targetAccuracy.lowerBound >= 0, targetAccuracy.upperBound <= 1 else {
            throw AdaptiveError.invalidConfiguration("targetAccuracy \(targetAccuracy) not within 0...1")
        }
        guard (1...Self.maximumWindowSize).contains(windowSize) else {
            throw AdaptiveError.invalidConfiguration("windowSize \(windowSize) not in 1...\(Self.maximumWindowSize)")
        }
        guard (1...windowSize).contains(minimumAnswers) else {
            throw AdaptiveError.invalidConfiguration("minimumAnswers \(minimumAnswers) not in 1...\(windowSize)")
        }
        let level = startingLevel ?? Self.middle(of: levels)
        guard levels.contains(level) else {
            throw AdaptiveError.invalidConfiguration("startingLevel \(level) not in \(levels)")
        }
        self.levels = levels
        self.targetAccuracy = targetAccuracy
        self.windowSize = windowSize
        self.minimumAnswers = minimumAnswers
        self.level = level
        self.recentAnswers = []
    }

    /// The share of correct answers in the window, or `nil` before the first answer.
    public var accuracy: Double? {
        recentAnswers.isEmpty ? nil : Double(recentAnswers.count { $0 }) / Double(recentAnswers.count)
    }

    /// Records an answer and adjusts the level.
    @discardableResult
    public mutating func record(correct: Bool) -> Change {
        recentAnswers.append(correct)
        if recentAnswers.count > windowSize { recentAnswers.removeFirst(recentAnswers.count - windowSize) }
        guard recentAnswers.count >= minimumAnswers, let accuracy else { return .unchanged }
        if accuracy > targetAccuracy.upperBound, level < levels.upperBound {
            level += 1
            recentAnswers.removeAll()
            return .raised
        }
        if accuracy < targetAccuracy.lowerBound, level > levels.lowerBound {
            level -= 1
            recentAnswers.removeAll()
            return .lowered
        }
        return .unchanged
    }

    /// The middle of a range, without overflowing for ranges wider than `Int.max`.
    private static func middle(of range: ClosedRange<Int>) -> Int {
        (range.lowerBound >> 1) + (range.upperBound >> 1) + (range.lowerBound & range.upperBound & 1)
    }

    private enum CodingKeys: String, CodingKey {
        case levels, targetAccuracy, windowSize, minimumAnswers, level, recentAnswers
    }

    /// Decodes a saved adjuster, checking its settings, level and window as the initializer does.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(
            levels: try container.decode(ClosedRange<Int>.self, forKey: .levels),
            startingLevel: try container.decode(Int.self, forKey: .level),
            targetAccuracy: try container.decode(ClosedRange<Double>.self, forKey: .targetAccuracy),
            windowSize: try container.decode(Int.self, forKey: .windowSize),
            minimumAnswers: try container.decode(Int.self, forKey: .minimumAnswers)
        )
        let answers = try container.decode([Bool].self, forKey: .recentAnswers)
        guard answers.count <= windowSize else {
            throw AdaptiveError.invalidConfiguration("\(answers.count) saved answers for a window of \(windowSize)")
        }
        recentAnswers = answers
    }
}

/// Errors thrown for adaptive-difficulty settings that are out of range.
public enum AdaptiveError: Error, Sendable, Hashable {
    /// A setting is out of range; the message names it.
    case invalidConfiguration(String)
}
