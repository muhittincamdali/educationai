import Foundation

// MARK: - Difficulty Level

/// Difficulty tier for cards, questions, and quizzes.
public enum DifficultyLevel: Int, Codable, Sendable, CaseIterable, Comparable, Hashable {
    case easy = 1
    case medium = 2
    case hard = 3
    case expert = 4

    public var displayName: String {
        switch self {
        case .easy:   return "Easy"
        case .medium: return "Medium"
        case .hard:   return "Hard"
        case .expert: return "Expert"
        }
    }

    /// A numeric weight used for scoring and adaptive algorithms.
    public var weight: Double {
        switch self {
        case .easy:   return 0.5
        case .medium: return 1.0
        case .hard:   return 1.5
        case .expert: return 2.0
        }
    }

    public static func < (lhs: DifficultyLevel, rhs: DifficultyLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

// MARK: - Recall Rating

/// Self-reported recall quality — maps to SM-2 quality grades.
public enum RecallRating: Int, Codable, Sendable, CaseIterable, Comparable {
    /// Complete blackout — no recall.
    case again = 0
    /// Incorrect but recognized on reveal.
    case hard = 1
    /// Correct with significant hesitation.
    case good = 2
    /// Correct with little hesitation.
    case easy = 3

    /// SM-2 quality value (0-5 scale).
    public var sm2Quality: Int {
        switch self {
        case .again: return 1
        case .hard:  return 2
        case .good:  return 4
        case .easy:  return 5
        }
    }

    /// Whether this rating counts as a correct recall.
    public var isCorrect: Bool {
        self >= .good
    }

    public var displayName: String {
        switch self {
        case .again: return "Again"
        case .hard:  return "Hard"
        case .good:  return "Good"
        case .easy:  return "Easy"
        }
    }

    public static func < (lhs: RecallRating, rhs: RecallRating) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
