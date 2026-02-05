import Foundation

/// A gamification badge awarded for milestones.
public struct Badge: Identifiable, Codable, Sendable, Hashable {

    public let id: UUID

    /// Machine-readable key (e.g. "streak_7", "mastery_first").
    public let key: String

    /// Human-readable title.
    public var title: String

    /// Description of how to earn this badge.
    public var description: String

    /// SF Symbol or custom icon name.
    public var iconName: String

    /// Tier for visual distinction.
    public var tier: BadgeTier

    /// When this badge was earned (nil if not yet earned).
    public var earnedAt: Date?

    /// Whether this badge has been earned.
    public var isEarned: Bool { earnedAt != nil }

    public init(
        id: UUID = UUID(),
        key: String,
        title: String,
        description: String,
        iconName: String = "star.fill",
        tier: BadgeTier = .bronze,
        earnedAt: Date? = nil
    ) {
        self.id = id
        self.key = key
        self.title = title
        self.description = description
        self.iconName = iconName
        self.tier = tier
        self.earnedAt = earnedAt
    }
}

/// Badge rarity / tier.
public enum BadgeTier: String, Codable, Sendable, CaseIterable, Comparable {
    case bronze
    case silver
    case gold
    case platinum
    case diamond

    public var displayName: String { rawValue.capitalized }

    public static func < (lhs: BadgeTier, rhs: BadgeTier) -> Bool {
        let order: [BadgeTier] = [.bronze, .silver, .gold, .platinum, .diamond]
        guard let li = order.firstIndex(of: lhs),
              let ri = order.firstIndex(of: rhs) else { return false }
        return li < ri
    }
}

/// XP event log entry.
public struct XPEvent: Identifiable, Codable, Sendable {
    public let id: UUID
    public let amount: Int
    public let reason: String
    public let timestamp: Date

    public init(id: UUID = UUID(), amount: Int, reason: String, timestamp: Date = Date()) {
        self.id = id
        self.amount = amount
        self.reason = reason
        self.timestamp = timestamp
    }
}

/// Streak information.
public struct StreakInfo: Codable, Sendable {
    /// Current consecutive-day streak.
    public var current: Int
    /// All-time longest streak.
    public var longest: Int
    /// Date of the last study day (calendar day).
    public var lastStudyDate: Date?

    public init(current: Int = 0, longest: Int = 0, lastStudyDate: Date? = nil) {
        self.current = current
        self.longest = longest
        self.lastStudyDate = lastStudyDate
    }
}
